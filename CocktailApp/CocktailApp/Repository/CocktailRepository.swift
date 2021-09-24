//
//  CocktailRepository.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/24.
//

import Foundation
import Moya
import RxSwift

class CocktailRepository {
    let service = MoyaProvider<CocktailAPI>()
    
    func fetchCocktails(type: ListType) -> Observable<[Cocktail]> {
        return service.rx.request(.cocktailsList(type: type))
            .asObservable()
            .map { response -> [Cocktail] in
                var cocktails = [Cocktail]()
                
                do {
                    let cocktailResponse = try JSONDecoder().decode(CocktailResponse.self, from: response.data)
                    cocktails = cocktailResponse.data
                } catch {
                    print("cannot decode response data : \(error.localizedDescription)")
                }
                
                return cocktails
            }
    }
}
