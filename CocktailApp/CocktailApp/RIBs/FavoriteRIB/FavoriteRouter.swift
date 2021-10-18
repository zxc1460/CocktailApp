//
//  FavoriteRouter.swift
//  CocktailApp
//
//

import RIBs

protocol FavoriteInteractable: Interactable, CocktailDetailListener {
    var router: FavoriteRouting? { get set }
    var listener: FavoriteListener? { get set }
}

protocol FavoriteViewControllable: ViewControllable {
}

final class FavoriteRouter: ViewableRouter<FavoriteInteractable, FavoriteViewControllable> {
    
    private let cocktailDetailBuilder: CocktailDetailBuildable
    private var cocktailDetailRouting: CocktailDetailRouting?

    init(interactor: FavoriteInteractable,
         viewController: FavoriteViewControllable,
         cocktailDetailBuilder: CocktailDetailBuildable) {
        self.cocktailDetailBuilder = cocktailDetailBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

extension FavoriteRouter: FavoriteRouting {
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
