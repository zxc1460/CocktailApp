//
//  Cocktail.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/23.
//

import Foundation

typealias Ingredient = (name: String, measure: String)

struct Cocktail: Codable {
    
    // MARK: - Properties
    
    let id: String
    let name: String
    let category: String?
    private let alcoholic: String?
    let thumbnail: String?
    private let strTags: String?
    let glass: String?
    let instruction: String?
    private let ingredient1: String?
    private let ingredient2: String?
    private let ingredient3: String?
    private let ingredient4: String?
    private let ingredient5: String?
    private let ingredient6: String?
    private let ingredient7: String?
    private let ingredient8: String?
    private let ingredient9: String?
    private let ingredient10: String?
    private let ingredient11: String?
    private let ingredient12: String?
    private let ingredient13: String?
    private let ingredient14: String?
    private let ingredient15: String?
    private let measure1: String?
    private let measure2: String?
    private let measure3: String?
    private let measure4: String?
    private let measure5: String?
    private let measure6: String?
    private let measure7: String?
    private let measure8: String?
    private let measure9: String?
    private let measure10: String?
    private let measure11: String?
    private let measure12: String?
    private let measure13: String?
    private let measure14: String?
    private let measure15: String?
    
    // MARK: - Computed Properties
    
    var isAlcohol: Bool {
        alcoholic ?? "" == "Alcoholic"
    }
    
    var tags: [String] {
        guard let strTags = strTags else {
            return []
        }
        
        return strTags.components(separatedBy: ",")
    }
    
    var ingredients: [Ingredient] {
        return [(ingredient1, measure1), (ingredient2, measure2), (ingredient3, measure3),
                (ingredient4, measure4), (ingredient5, measure5), (ingredient6, measure6),
                (ingredient7, measure7), (ingredient8, measure8), (ingredient9, measure9),
                (ingredient10, measure10), (ingredient11, measure11), (ingredient12, measure12),
                (ingredient13, measure13), (ingredient14, measure14), (ingredient15, measure15)]
            .filter { $0.0 != nil && $0.1 != nil && $0.0!.count > 0 && $0.1!.count > 0 }
            .compactMap { (name: $0.0!, measure: $0.1!) }
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "idDrink"
        case name = "strDrink"
        case strTags
        case category = "strCategory"
        case alcoholic = "strAlcoholic"
        case thumbnail = "strDrinkThumb"
        case glass = "strGlass"
        case instruction = "strInstructions"
        case ingredient1 = "strIngredient1"
        case ingredient2 = "strIngredient2"
        case ingredient3 = "strIngredient3"
        case ingredient4 = "strIngredient4"
        case ingredient5 = "strIngredient5"
        case ingredient6 = "strIngredient6"
        case ingredient7 = "strIngredient7"
        case ingredient8 = "strIngredient8"
        case ingredient9 = "strIngredient9"
        case ingredient10 = "strIngredient10"
        case ingredient11 = "strIngredient11"
        case ingredient12 = "strIngredient12"
        case ingredient13 = "strIngredient13"
        case ingredient14 = "strIngredient14"
        case ingredient15 = "strIngredient15"
        case measure1 = "strMeasure1"
        case measure2 = "strMeasure2"
        case measure3 = "strMeasure3"
        case measure4 = "strMeasure4"
        case measure5 = "strMeasure5"
        case measure6 = "strMeasure6"
        case measure7 = "strMeasure7"
        case measure8 = "strMeasure8"
        case measure9 = "strMeasure9"
        case measure10 = "strMeasure10"
        case measure11 = "strMeasure11"
        case measure12 = "strMeasure12"
        case measure13 = "strMeasure13"
        case measure14 = "strMeasure14"
        case measure15 = "strMeasure15"
    }
}
