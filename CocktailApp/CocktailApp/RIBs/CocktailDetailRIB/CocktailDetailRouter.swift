//
//  CocktailDetailRouter.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/27.
//

import RIBs

protocol CocktailDetailInteractable: Interactable {
    var router: CocktailDetailRouting? { get set }
    var listener: CocktailDetailListener? { get set }
}

protocol CocktailDetailViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class CocktailDetailRouter: ViewableRouter<CocktailDetailInteractable, CocktailDetailViewControllable>, CocktailDetailRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: CocktailDetailInteractable, viewController: CocktailDetailViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
