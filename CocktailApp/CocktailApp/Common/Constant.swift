//
//  Constant.swift
//  CocktailApp
//
//

import Foundation

struct Constant {
    static let shared = Constant()
    
    let baseURL = "https://the-cocktail-db.p.rapidapi.com"
    let host = "the-cocktail-db.p.rapidapi.com"
    let key: String
    
    private init() {
        guard let path = Bundle.main.path(forResource: "keys", ofType: "plist") else {
            fatalError("couldn't find file named 'keys.plist'")
        }
        
        let dict = NSDictionary(contentsOfFile: path)
        
        guard let key = dict?.object(forKey: "apiKey") as? String else {
            fatalError("couldn't find 'apiKey' in 'keys.plist'")
        }
        
        self.key = key
    }
}
