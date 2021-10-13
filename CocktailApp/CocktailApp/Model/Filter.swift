//
//  Filter.swift
//  CocktailApp
//
//

struct Filter: Codable {
    let ingredient: String?
    let glass: String?
    let category: String?
    
    enum CodingKeys: String, CodingKey {
        case ingredient = "strIngredient1"
        case glass = "strGlass"
        case category = "strCategory"
    }
}
