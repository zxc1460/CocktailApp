//
//  SearchFilterRouter.swift
//  CocktailApp
//
//

import RIBs

protocol SearchFilterInteractable: Interactable, FilterListener, CocktailDetailListener {
    var router: SearchFilterRouting? { get set }
    var listener: SearchFilterListener? { get set }
}

protocol SearchFilterViewControllable: ViewControllable {
}

final class SearchFilterRouter: ViewableRouter<SearchFilterInteractable, SearchFilterViewControllable> {
    
    // MARK: - Private
    
    private let filterBuilder: FilterBuildable
    private var filterRouting: FilterRouting?
    
    private let cocktailDetailBuilder: CocktailDetailBuildable
    private var cocktailDetailRouting: CocktailDetailRouting?
    
    init(
        interactor: SearchFilterInteractable,
        viewController: SearchFilterViewControllable,
        filterBuilder: FilterBuildable,
        cocktailDetailBuilder: CocktailDetailBuildable
    ) {
        self.filterBuilder = filterBuilder
        self.cocktailDetailBuilder = cocktailDetailBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

extension SearchFilterRouter: SearchFilterRouting {
    func attachFilter() {
        let filterRouting = filterBuilder.build(withListener: interactor)
        attachChild(filterRouting)
        self.filterRouting = filterRouting
    }
    
    func routeToDetail(id: String) {
        let cocktailDetailRouting = cocktailDetailBuilder.build(withListener: interactor, id: id)
        attachChild(cocktailDetailRouting)
        self.cocktailDetailRouting = cocktailDetailRouting
        viewController.pushViewController(viewControllable: cocktailDetailRouting.viewControllable)
    }
    
    func detachDetail() {
        if let routing = cocktailDetailRouting {
            detachChild(routing)
            viewControllable.popViewController(viewControllable: routing.viewControllable)
        }
    }
}
