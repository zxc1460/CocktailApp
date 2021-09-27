//
//  CocktailListRouter.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/23.
//

import RIBs

protocol CocktailListInteractable: Interactable, CocktailDetailListener {
    var router: CocktailListRouting? { get set }
    var listener: CocktailListListener? { get set }
}

protocol CocktailListViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class CocktailListRouter: ViewableRouter<CocktailListInteractable, CocktailListViewControllable> {
    private let cocktailDetailBuilder: CocktailDetailBuildable
    private var cocktailDetailRouting: CocktailDetailRouting?

    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: CocktailListInteractable,
         viewController: CocktailListViewControllable,
         cocktailDetailBuilder: CocktailDetailBuildable) {
        self.cocktailDetailBuilder = cocktailDetailBuilder
        
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

extension CocktailListRouter: CocktailListRouting {
    func routeToDetail(cocktail: Cocktail) {
        let cocktailDetailRouting = cocktailDetailBuilder.build(withListener: interactor, cocktail: cocktail)
        
        self.cocktailDetailRouting = cocktailDetailRouting
        
        attachChild(cocktailDetailRouting)
        viewController.pushViewController(viewController: cocktailDetailRouting.viewControllable)
    }
    
    func popFromChild() {
        if let routing = cocktailDetailRouting {
            detachChild(routing)
            viewController.popViewController(viewController: routing.viewControllable)
            cocktailDetailRouting = nil
        }
    }
}
