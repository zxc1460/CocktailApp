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
    
    // API 호출로 가져온 칵테일 값들이 DB에 저장된지 확인하고 저장이 안 되어 있으면 저장 후 DB 모델 배열로 반환
    private func readAndWriteCocktailList(list: [Cocktail]) -> [CocktailData] {
        var result = [CocktailData]()
        
        for data in list {
            if let savedData = self.cocktailDAO.read(id: data.id) {
                result.append(savedData)
            } else {
                let cocktailData = CocktailData(data)
                self.cocktailDAO.insert(data: cocktailData)
                result.append(cocktailData)
            }
        }
        
        return result
    }
    
    // API 호출(칵테일 디테일)
    private func fetchCocktail(id: String) -> Observable<CocktailData> {
        self.cocktailService.rx.request(.detail(id: id))
            .asObservable()
            .map(CocktailResponse.self)
            .compactMap { $0.data?.first }
            .map { CocktailData($0) }
    }
    
    // MARK: - Public
    
    func loadCocktailList(type: ListType) -> Single<[CocktailData]> {
        return Single<[CocktailData]>.create { [weak self] single in
            guard let self = self else {
                fatalError("reference of CocktailRepository already released is used.")
            }
            
            let disposable = self.fetchCocktailList(type: type)
                .subscribe(onNext: { list in
                    single(.success(self.readAndWriteCocktailList(list: list)))
                })
            
            return Disposables.create { disposable.dispose() }
        }
    }
    
    func loadCocktail(id: String) -> Observable<CocktailData?> {
        if let data = self.cocktailDAO.read(id: id) {
            return Observable.just(data)
        }
        
        return Observable<CocktailData?>.create { [weak self] observer in
            guard let self = self else {
                fatalError("reference of CocktailRepository already released is used.")
            }
            
            let disposable = self.fetchCocktail(id: id)
                .subscribe(onNext: { cocktail in
                    self.cocktailDAO.insert(data: cocktail)
                    observer.onNext(cocktail)
                }, onCompleted: {
                    observer.onCompleted()
                })
            
            return Disposables.create { disposable.dispose() }
        }
    }
    
    func loadFavoriteCocktailList() -> Observable<[CocktailData]> {
        let favorites = cocktailDAO.read(isFavorite: true)
        
        return Observable.array(from: favorites)
    }
    
    func notifyFavoriteChanges() -> Observable<CocktailData> {
        let cocktails = cocktailDAO.read()
        
        return Observable.changeset(from: cocktails)
            .map { results, changes in
                guard let index = changes?.updated.first else {
                    return nil
                }
                
                return results[index]
            }
            .compactMap { $0 }
    }
    
    func searchCocktailList(name: String) -> Observable<[CocktailData]> {
        guard name.count > 0 else {
            return Observable.just([])
                .asObservable()
        }
        
        return Observable<[CocktailData]>.create { [weak self] observer in
            guard let self = self else {
                fatalError("reference of CocktailRepository already released is used.")
            }
            
            let disposable = self.cocktailService.rx.request(.search(name: name))
                .asObservable()
                .map(CocktailResponse.self)
                .compactMap { $0.data }
                .subscribe(onNext: { list in
                    let result = self.readAndWriteCocktailList(list: list)
                    observer.onNext(result)
                }, onCompleted: {
                    observer.onCompleted()
                })
            
            
            return Disposables.create { disposable.dispose() }
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
        guard data.isFavorite != isFavorite else {
            return
        }
        
        self.cocktailDAO.update(data: data, isFavorite: isFavorite)
    }
}
