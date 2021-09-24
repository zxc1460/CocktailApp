//
//  Cocktail.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/23.
//

import Foundation

struct Cocktail: Codable {
    let id: String
    let name: String
    let category: String
    let alcoholic: String?
    let thumbnail: String
    
    var isAlcohol: Bool {
        return alcoholic ?? "" == "Alcoholic"
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "idDrink"
        case name = "strDrink"
        case category = "strCategory"
        case alcoholic = "strAlcoholic"
        case thumbnail = "strDrinkThumb"
    }
}
