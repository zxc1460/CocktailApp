//
//  Filter.swift
//  CocktailApp
//
//

struct Filter: Decodable {
    let ingredient: String?
    let glass: String?
    let category: String?
    
    enum CodingKeys: String, CodingKey {
        case ingredient = "strIngredient1"
        case glass = "strGlass"
        case category = "strCategory"
    }
}
