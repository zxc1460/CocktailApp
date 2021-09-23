//
//  AppComponent.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/23.
//

import RIBs

class AppComponent: Component<EmptyComponent>, RootDependency {
    init() {
        super.init(dependency: EmptyComponent())
    }
}
