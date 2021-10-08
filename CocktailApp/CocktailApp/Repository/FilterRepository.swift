//
//  FilterRepository.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/10/08.
//

import Foundation
import Moya
import RealmSwift
import RxMoya
import RxSwift


final class FilterRepository {
    private let service: MoyaProvider<FilterAPI>
    private let dao: FilterDAO
    
    init() {
        self.service = MoyaProvider<FilterAPI>()
        self.dao = FilterDAO()
    }
    
    var isEmptyFilters: Bool {
        for type in FilterType.allCases {
            if dao.read(type: type).count > 0 {
                return true
            }
        }
        
        return false
    }
    
    func saveFilterContentsFromAPI() -> Completable {
        let requests = FilterType.allCases
            .map { service.rx.request(.list(type: $0))
                        .asObservable()
                        .map(FilterResponse.self)
                        .compactMap { $0.data }
            }
        
        return Completable.create { completable in
            let disposable = Observable.combineLatest(requests)
                .debug()
                .subscribe(with: self,
                           onNext: { owner, datas in
                    for (index, data) in datas.enumerated() {
                        let contents = data.map { value -> String in
                            var result = String()
                            if let ingredient = value.ingredient {
                                result = ingredient
                            } else if let category = value.category {
                                result = category
                            } else if let glass = value.glass {
                                result = glass
                            }
                            
                            return result
                        }
                        
                        let sortedContents = contents.sorted().toList()
                        
                        let filterData = FilterData(type: FilterType.allCases[index], contents: sortedContents)
                        
                        owner.dao.insert(filterData)
                    }
                },
                           onCompleted: { _ in
                    completable(.completed)
                })
            
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
    func fetchFilterContents(type: FilterType) -> [String] {
        guard let data = dao.read(type: type).first else {
            return []
        }
        
        return Array(data.contents).sorted()
    }
    
}
