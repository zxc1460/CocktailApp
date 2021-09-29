//
//  CocktailRepository.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/24.
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
            .map { $0.data }
    }
    
    func fetchCocktailDetail(from id: String) -> Observable<Cocktail?> {
        return cocktailService.rx.request(.detail(id: id))
            .asObservable()
            .map(CocktailResponse.self)
            .map { $0.data.first }
    }
}
