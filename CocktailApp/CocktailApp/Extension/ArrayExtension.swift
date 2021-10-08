//
//  ArrayExtension.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/10/08.
//

import Foundation
import RealmSwift

extension Array where Element: RealmCollectionValue {
    func toList() -> List<Element> {
        let list = List<Element>()
        
        for value in self {
            list.append(value)
        }
        
        return list
    }
}
