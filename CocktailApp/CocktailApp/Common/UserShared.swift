//
//  UserShared.swift
//  CocktailApp
//
//

import Foundation

enum UserShared {
    enum Info {
        @UserDefault(key: "LAST_FILTER_SAVE")
        static var lastFilterSaveTime: String
    }
}
