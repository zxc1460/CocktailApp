//
//  CocktailRepository.swift
//  CocktailApp
//
// 

import Foundation
import Moya
import Realm
import RxMoya
import RxRealm
import RxSwift

final class CocktailRepository {
    private let cocktailService: MoyaProvider<CocktailAPI>
    private let cocktailDAO: CocktailDAO
    
    init() {
        self.cocktailService = MoyaProvider<CocktailAPI>()
        self.cocktailDAO = CocktailDAO()
    }
    
    // MARK: - Private
    
    // API 호출(칵테일 리스트)
    private func fetchCocktailList(type: ListType) -> Observable<[Cocktail]> {
        return cocktailService.rx.request(.cocktailList(type: type))
            .asObservable()
            .map(CocktailResponse.self)
            .compactMap { $0.data }
    }
    
    private func fetchCocktailList(name: String) -> Observable<[Cocktail]> {
        return cocktailService.rx.request(.search(name: name))
            .asObservable()
            .map(CocktailResponse.self)
            .map { $0.data ?? [] }
    }
    
    // API 호출로 가져온 칵테일 값들이 DB에 저장된지 확인하고 저장이 안 되어 있으면 저장 후 DB 모델 배열로 반환
    private func insertCocktailList(list: [Cocktail]) -> [CocktailData] {
        return list.reduce(into: [CocktailData]()) { [weak self] arr, data in
            guard let self = self else { return }
            
            if let savedData = self.cocktailDAO.read(id: data.id) {
                arr.append(savedData)
            } else {
                arr.append(self.insertCocktail(data))
            }
        }
    }
    
    // API 호출(칵테일 디테일)
    private func fetchCocktail(id: String) -> Observable<Cocktail> {
        return cocktailService.rx.request(.detail(id: id))
            .asObservable()
            .map(CocktailResponse.self)
            .compactMap { $0.data?.first }
    }
    
    // Cocktail 로컬 DB에 저장
    private func insertCocktail(_ cocktail: Cocktail) -> CocktailData {
        let data = CocktailData(cocktail)
        self.cocktailDAO.insert(data: data)
        return data
    }
    
    // MARK: - Public
    
    func loadCocktailList(type: ListType) -> Observable<[CocktailData]> {
        return fetchCocktailList(type: type)
            .withUnretained(self)
            .map { owner, data in
                owner.insertCocktailList(list: data)
            }
    }
    
    func loadCocktail(id: String) -> Observable<CocktailData> {
        if let data = self.cocktailDAO.read(id: id) {
            return Observable.just(data)
        }
        
        return fetchCocktail(id: id)
            .withUnretained(self)
            .map { owner, data in
                return owner.insertCocktail(data)
            }
    }
    
    func loadFavoriteCocktailList() -> Observable<[CocktailData]> {
        let favorites = cocktailDAO.read(isFavorite: true)
        
        return Observable.array(from: favorites)
    }
    
    func notifyFavoriteChanges() -> Observable<CocktailData> {
        let cocktails = cocktailDAO.read()
        
        return Observable.changeset(from: cocktails)
            .compactMap { results, changes in
                guard let index = changes?.updated.first else {
                    return nil
                }
                
                return results[index]
            }
    }
    
    func searchCocktailList(name: String) -> Observable<[CocktailData]> {
        guard name.count > 0 else { return Observable.just([]) }
        
        return fetchCocktailList(name: name)
            .withUnretained(self)
            .map { owner, data in
                owner.insertCocktailList(list: data)
            }
    }
    
    func searchCocktail(type: FilterType, keyword: String) -> Observable<[CocktailSnippet]> {
        return cocktailService.rx.request(.filter(type: type, keyword: keyword))
            .asObservable()
            .map { try JSONDecoder().decode(CocktailSnippetResponse.self, from: $0.data) }
            .catchAndReturn(CocktailSnippetResponse(data: []))
            .compactMap { $0.data }
    }
    
    func updateCocktail(data: CocktailData, isFavorite: Bool) {
        guard data.isFavorite != isFavorite else { return }
        
        self.cocktailDAO.update(data: data, isFavorite: isFavorite)
    }
}
