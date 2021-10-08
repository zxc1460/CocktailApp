//
//  FilterDAO.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/10/08.
//

import Foundation
import RealmSwift

struct FilterDAO {
    func read() -> Results<FilterData> {
        return RealmManager.read(FilterData.self)
    }
    
    func read(type: FilterType) -> Results<FilterData> {
        return read()
            .filter([.equal], \FilterData.type, type.rawValue)
    }
    
    func insert(_ data: FilterData) {
        let oldData = read(type: data.type)
    
        if !oldData.isEmpty {
            delete(type: data.type)
        }
        
        RealmManager.add(data)
    }
    
    func delete(type: FilterType) {
        if let data = read(type: type).first {
            RealmManager.delete(data)
        }
    }
}
