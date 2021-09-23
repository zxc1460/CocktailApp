//
//  CocktailListRouter.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/23.
//

import RIBs

protocol CocktailListInteractable: Interactable {
    var router: CocktailListRouting? { get set }
    var listener: CocktailListListener? { get set }
}

protocol CocktailListViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class CocktailListRouter: ViewableRouter<CocktailListInteractable, CocktailListViewControllable>, CocktailListRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: CocktailListInteractable, viewController: CocktailListViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
