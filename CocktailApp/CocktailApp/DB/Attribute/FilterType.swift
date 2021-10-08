//
//  FilterType.swift
//  CocktailApp
//
//

import Foundation
import RealmSwift

enum FilterType: String, PersistableEnum {
    case ingredient = "i"
    case category = "g"
    case glass = "c"
}
