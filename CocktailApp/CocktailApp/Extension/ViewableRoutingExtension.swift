//
//  ViewableRouting.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/10/01.
//

import RIBs

extension ViewableRouting {
    func detachChildren() {
        children.forEach {
            detachChild($0)
        }
    }
}
