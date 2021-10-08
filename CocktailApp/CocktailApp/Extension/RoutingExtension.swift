//
//  ViewableRouting.swift
//  CocktailApp
//
//

import RIBs

extension Routing {
    func detachChildren() {
        children.forEach {
            detachChild($0)
        }
    }
}
