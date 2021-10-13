//
//  CocktailSnippetResponse.swift
//  CocktailApp
//
//

import Foundation

struct CocktailSnippetResponse: Codable {
    let data: [CocktailSnippet]?
    
    init(data: [CocktailSnippet]) {
        self.data = data
    }
    
    enum CodingKeys: String, CodingKey {
        case data = "drinks"
    }
}
