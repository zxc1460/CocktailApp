//
//  FilterData.swift
//  CocktailApp
//
//

import Foundation
import RealmSwift

class FilterData: Object {
    @Persisted(primaryKey: true) var type: FilterType
    @Persisted var keywords = List<String>()
    
    override init() {}
    
    init(type: FilterType, keywords: List<String>) {
        super.init()
        
        self.type = type
        self.keywords = keywords
    }
}
