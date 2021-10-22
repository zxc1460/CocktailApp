//
//  CocktailSnippet.swift
//  CocktailApp
//
//

import Foundation


struct CocktailSnippet: Codable {
    let id: String
    let name: String
    let thumbnail: String?
    
    // MARK: - CodingKeys
    
    enum CodingKeys: String, CodingKey {
        case id = "idDrink"
        case name = "strDrink"
        case thumbnail = "strDrinkThumb"
    }
}
