//
//  UserDefaultWrapper.swift
//  CocktailApp
//
//

import Foundation

@propertyWrapper
class UserDefault<T> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
            UserDefaults.standard.synchronize()
        }
    }
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

// MARK: - Extension

extension UserDefault where T == String {
    convenience init(key: String) {
        self.init(key: key, defaultValue: String())
    }
}
