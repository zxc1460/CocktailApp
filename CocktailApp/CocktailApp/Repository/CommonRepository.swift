//
//  CommonRepository.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/10/08.
//

import Foundation

final class CommonRepository {
    lazy var cocktail = CocktailRepository()
    lazy var filter = FilterRepository()
}
