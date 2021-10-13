//
//  FilterRouter.swift
//  CocktailApp
//
//

import RIBs

protocol FilterInteractable: Interactable {
    var router: FilterRouting? { get set }
    var listener: FilterListener? { get set }
}

protocol FilterViewControllable: ViewControllable {
}

final class FilterRouter: Router<FilterInteractable>, FilterRouting {

    init(interactor: FilterInteractable, viewController: FilterViewControllable) {
        self.viewController = viewController
        super.init(interactor: interactor)
        interactor.router = self
    }

    func cleanupViews() {
    }

    // MARK: - Private

    private let viewController: FilterViewControllable
}
