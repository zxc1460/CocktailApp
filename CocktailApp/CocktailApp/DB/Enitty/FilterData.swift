//
//  FilterData.swift
//  CocktailApp
//
//

import Foundation
import RealmSwift

class FilterData: Object {
    @Persisted(primaryKey: true) var type: FilterType
    @Persisted var contents = List<String>()
    
    override init() {}
    
    init(type: FilterType, contents: List<String>) {
        super.init()
        
        self.type = type
        self.contents = contents
    }
}
