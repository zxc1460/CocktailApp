//
//  CocktailData.swift
//  CocktailApp
//
//

import Foundation
import RealmSwift
import RxRealm
import RxSwift

class CocktailData: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
    @Persisted var category: String?
    @Persisted var alcoholic: String?
    @Persisted var thumbnail: String?
    @Persisted var glass: String?
    @Persisted var instruction: String?
    @Persisted var isAlcohol: Bool
    @Persisted var tags: List<String>
    @Persisted var ingredients: List<CocktailIngredient>
    @Persisted var isFavorite = false
    
    override init() {}
    
    init(_ cocktail: Cocktail) {
        super.init()
        self.id = cocktail.id
        self.name = cocktail.name
        self.category = cocktail.category
        self.thumbnail = cocktail.thumbnail
        self.glass = cocktail.glass
        self.instruction = cocktail.instruction
        self.isAlcohol = cocktail.isAlcohol
        self.tags = cocktail.tags.toList()
        self.ingredients = cocktail.ingredients.map { CocktailIngredient($0) }.toList()
    }
    
    var isFavoriteChanged: Observable<Bool> {
        return Observable.from(object: self, properties: ["isFavorite"])
            .map { $0.isFavorite }
    }
}

class CocktailIngredient: Object {
    @Persisted var name: String
    @Persisted var measure: String
    
    override init() {}
    
    init(_ ingredient: Ingredient) {
        self.name = ingredient.name
        self.measure = ingredient.measure
    }
}
