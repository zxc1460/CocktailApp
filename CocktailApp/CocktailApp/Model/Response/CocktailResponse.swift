//
//  CocktailResponse.swift
//  CocktailApp
//
// 

import Foundation

struct CocktailResponse: Codable {
    let data: [Cocktail]?
    
    enum CodingKeys: String, CodingKey {
        case data = "drinks"
    }
}
