//
//  CocktailResponse.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/24.
//

import Foundation

struct CocktailResponse: Codable {
    let data: [Cocktail]
    
    enum CodingKeys: String, CodingKey {
        case data = "drinks"
    }
}
