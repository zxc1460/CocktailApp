//
//  CocktailRepository.swift
//  CocktailApp
//
// 

import Foundation
import Moya
import RxMoya
import RxSwift

final class CocktailRepository {
    private let cocktailService: MoyaProvider<CocktailAPI>
    
    init() {
        self.cocktailService = MoyaProvider<CocktailAPI>()
    }
    
    func fetchCocktailList(of type: ListType) -> Observable<[Cocktail]> {
        return cocktailService.rx.request(.cocktailList(type: type))
            .asObservable()
            .map(CocktailResponse.self)
            .compactMap { $0.data }
    }
    
    func fetchCocktailDetail(from id: String) -> Observable<Cocktail?> {
        return cocktailService.rx.request(.detail(id: id))
            .asObservable()
            .map(CocktailResponse.self)
            .compactMap { $0.data }
            .map { $0.first }
    }
    
    func searchCocktail(name: String) -> Observable<[Cocktail]> {
        guard name.count > 0 else {
            return Observable.just([])
                .asObservable()
        }
        
        return cocktailService.rx.request(.search(name: name))
            .asObservable()
            .map(CocktailResponse.self)
            .compactMap { $0.data }
    }
    
    func searchCocktail(type: FilterType, keyword: String) -> Observable<[CocktailSnippet]> {
        return cocktailService.rx.request(.filter(type: type, keyword: keyword))
            .asObservable()
            .map { try JSONDecoder().decode(CocktailSnippetResponse.self, from: $0.data) }
            .catchAndReturn(CocktailSnippetResponse(data: []))
            .compactMap { $0.data }
    }
}
