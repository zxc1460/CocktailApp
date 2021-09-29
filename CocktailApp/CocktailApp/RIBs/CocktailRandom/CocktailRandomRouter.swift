//
//  CocktailRandomRouter.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/28.
//

import RIBs

protocol CocktailRandomInteractable: Interactable, CocktailDetailListener {
    var router: CocktailRandomRouting? { get set }
    var listener: CocktailRandomListener? { get set }
}

protocol CocktailRandomViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class CocktailRandomRouter: ViewableRouter<CocktailRandomInteractable, CocktailRandomViewControllable> {
    private let cocktailDetailBuilder: CocktailDetailBuildable
    private var cocktailDetailRouting: CocktailDetailRouting?

    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: CocktailRandomInteractable,
                  viewController: CocktailRandomViewControllable,
                  cocktailDetailBuilder: CocktailDetailBuildable) {
        self.cocktailDetailBuilder = cocktailDetailBuilder
        
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

extension CocktailRandomRouter: CocktailRandomRouting {
    func routeToDetail(cocktail: Cocktail) {
        let cocktailDetailRouting = cocktailDetailBuilder.build(withListener: interactor, cocktail: cocktail)
        
        self.cocktailDetailRouting = cocktailDetailRouting
        
        attachChild(cocktailDetailRouting)
        viewController.pushViewController(viewController: cocktailDetailRouting.viewControllable)
    }
    
    func detachChildRIB() {
        if let routing = cocktailDetailRouting {
            detachChild(routing)
            viewController.popViewController(viewController: routing.viewControllable)
            cocktailDetailRouting = nil
        }
    }
}
