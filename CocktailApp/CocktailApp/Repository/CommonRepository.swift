//
//  CommonRepository.swift
//  CocktailApp
//
//

import Foundation

final class CommonRepository {
    lazy var cocktail = CocktailRepository()
    lazy var filter = FilterRepository()
}
