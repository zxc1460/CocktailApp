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
    
    func saveFilterKeywordsFromAPI() -> Completable {
        let requests = FilterType.allCases
            .map { service.rx.request(.list(type: $0))
                        .asObservable()
                        .map(FilterResponse.self)
                        .compactMap { $0.data }
            }
        
        return Completable.create { completable in
            let disposable = Observable.combineLatest(requests)
                .subscribe(with: self,
                           onNext: { owner, datas in
                    for (index, data) in datas.enumerated() {
                        let contents = data.map { value -> String in
                            return value.ingredient ?? value.category ?? value.glass ?? String()
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
    
    func fetchFilterKeywords(type: FilterType) -> Observable<[String]> {
        guard let data = dao.read(type: type).first else {
            return Observable.just([])
        }
        
        return Observable.just(Array(data.contents).sorted())
    }
    
}
