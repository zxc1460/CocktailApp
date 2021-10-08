//
//  CocktailDetailRouter.swift
//  CocktailApp
//
//

import RIBs

protocol CocktailDetailInteractable: Interactable {
    var router: CocktailDetailRouting? { get set }
    var listener: CocktailDetailListener? { get set }
}

protocol CocktailDetailViewControllable: ViewControllable {
}

final class CocktailDetailRouter: ViewableRouter<CocktailDetailInteractable, CocktailDetailViewControllable>, CocktailDetailRouting {
    override init(interactor: CocktailDetailInteractable, viewController: CocktailDetailViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
