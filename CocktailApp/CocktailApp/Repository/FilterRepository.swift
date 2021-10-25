//
//  FilterRepository.swift
//  CocktailApp
//
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
    
    private func insertKeyword(type: FilterType, data: [Filter]) {
        let keywords = data.map {
            return $0.ingredient ?? $0.category ?? $0.glass ?? String()
        }.sorted().toList()
        
        let filterData = FilterData(type: type, keywords: keywords)
        
        dao.insert(filterData)
    }
    
    func writeFilterKeywords() -> Completable {
        let requests = FilterType.allCases
            .map { service.rx.request(.list(type: $0))
                        .asObservable()
                        .map(FilterResponse.self)
                        .compactMap { $0.data }
            }
        
        return Observable.combineLatest(requests)
                .withUnretained(self)
                .map { owner, datas -> Void in
                    datas.enumerated().forEach { index, data in
                        owner.insertKeyword(type: FilterType.allCases[index], data: data)
                    }
                }
                .ignoreElements()
                .asCompletable()
    }
    
    func loadFilterKeywords(type: FilterType) -> Observable<[String]> {
        guard let data = dao.read(type: type).first else {
            return Observable.just([])
        }
        
        let keywords = Array(data.keywords).sorted()
        
        return Observable.just(keywords)
    }
    
}
