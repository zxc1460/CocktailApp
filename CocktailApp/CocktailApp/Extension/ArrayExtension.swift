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
        return self.reduce(List<Element>()) { list, nextObject in
            list.append(nextObject)
            return list
        }
    }
}
