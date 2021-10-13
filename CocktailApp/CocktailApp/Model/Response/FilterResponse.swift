//
//  FilterResponse.swift
//  CocktailApp
//
//

struct FilterResponse: Codable {
    let data: [Filter]?
    
    enum CodingKeys: String, CodingKey {
        case data = "drinks"
    }
}
