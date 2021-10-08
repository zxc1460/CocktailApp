//
//  AppComponent.swift
//  CocktailApp
//
// 

import RIBs

class AppComponent: Component<EmptyComponent>, RootDependency {
    init() {
        super.init(dependency: EmptyComponent())
    }
}
