//
//  SearchNameRouter.swift
//  CocktailApp
//
//

import RIBs

protocol SearchNameInteractable: Interactable, CocktailDetailListener {
    var router: SearchNameRouting? { get set }
    var listener: SearchNameListener? { get set }
}

protocol SearchNameViewControllable: ViewControllable {
}

final class SearchNameRouter: ViewableRouter<SearchNameInteractable, SearchNameViewControllable> {
    private let cocktailDetailBuilder: CocktailDetailBuildable
    private var cocktailDetailRouting: CocktailDetailRouting?

    init(
        interactor: SearchNameInteractable,
        viewController: SearchNameViewControllable,
        cocktailDetailBuilder: CocktailDetailBuildable
    ) {
        self.cocktailDetailBuilder = cocktailDetailBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

// MARK: - Routing

extension SearchNameRouter: SearchNameRouting {
    func routeToDetail(cocktail: CocktailData) {
        let cocktailDetailRouting = cocktailDetailBuilder.build(withListener: interactor, cocktail: cocktail)
        self.cocktailDetailRouting = cocktailDetailRouting
        attachChild(cocktailDetailRouting)
        viewController.pushViewController(viewControllable: cocktailDetailRouting.viewControllable)
    }
    
    func detachDetail() {
        if let routing = cocktailDetailRouting {
            detachChild(routing)
            viewControllable.popViewController(viewControllable: routing.viewControllable)
            cocktailDetailRouting = nil
        }
    }
}
