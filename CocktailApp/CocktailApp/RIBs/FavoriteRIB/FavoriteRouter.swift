//
//  FavoriteRouter.swift
//  CocktailApp
//
//

import RIBs

protocol FavoriteInteractable: Interactable {
    var router: FavoriteRouting? { get set }
    var listener: FavoriteListener? { get set }
}

protocol FavoriteViewControllable: ViewControllable {
}

final class FavoriteRouter: ViewableRouter<FavoriteInteractable, FavoriteViewControllable>, FavoriteRouting {

    override init(interactor: FavoriteInteractable, viewController: FavoriteViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
