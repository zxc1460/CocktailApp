//
//  CocktailListRouter.swift
//  CocktailApp
//
//

import RIBs

protocol CocktailListInteractable: Interactable, CocktailDetailListener {
    var router: CocktailListRouting? { get set }
    var listener: CocktailListListener? { get set }
}

protocol CocktailListViewControllable: ViewControllable {
}

final class CocktailListRouter: ViewableRouter<CocktailListInteractable, CocktailListViewControllable> {
    private let cocktailDetailBuilder: CocktailDetailBuildable
    private var cocktailDetailRouting: CocktailDetailRouting?

    init(interactor: CocktailListInteractable,
         viewController: CocktailListViewControllable,
         cocktailDetailBuilder: CocktailDetailBuildable) {
        self.cocktailDetailBuilder = cocktailDetailBuilder
        
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

extension CocktailListRouter: CocktailListRouting {
    func routeToDetail(cocktail: CocktailData) {
        let cocktailDetailRouting = cocktailDetailBuilder.build(withListener: interactor, cocktail: cocktail)
        
        self.cocktailDetailRouting = cocktailDetailRouting
        
        attachChild(cocktailDetailRouting)
        viewController.pushViewController(viewControllable: cocktailDetailRouting.viewControllable)
    }
    
    func detachChildRIB() {
        if let routing = cocktailDetailRouting {
            detachChild(routing)
            viewController.popViewController(viewControllable: routing.viewControllable)
            cocktailDetailRouting = nil
        }
    }
}
