//
//  SearchFilterRouter.swift
//  CocktailApp
//
//

import RIBs

protocol SearchFilterInteractable: Interactable {
    var router: SearchFilterRouting? { get set }
    var listener: SearchFilterListener? { get set }
}

protocol SearchFilterViewControllable: ViewControllable {
}

final class SearchFilterRouter: ViewableRouter<SearchFilterInteractable, SearchFilterViewControllable>, SearchFilterRouting {
    override init(interactor: SearchFilterInteractable, viewController: SearchFilterViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
