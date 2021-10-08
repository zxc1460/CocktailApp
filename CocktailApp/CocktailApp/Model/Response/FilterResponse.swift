//
//  FilterResponse.swift
//  CocktailApp
//
//

struct FilterResponse: Decodable {
    let data: [Filter]?
    
    enum CodingKeys: String, CodingKey {
        case data = "drinks"
    }
}
