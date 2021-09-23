//
//  RootRouter.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/23.
//

import RIBs

protocol RootInteractable: Interactable, CocktailListListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func addViewController(_ viewControllable: ViewControllable, type: TabItemType)
    func moveToViewController(type: TabItemType)
}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {
    private let cocktailListBuilder: CocktailListBuildable
    private var cocktailListRouting: CocktailListRouting?

    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: RootInteractable,
        viewController: RootViewControllable,
        cocktailListBuilder: CocktailListBuildable) {
        self.cocktailListBuilder = cocktailListBuilder
        
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    override func didLoad() {
        super.didLoad()
        buildCocktailList()
        routeToCocktailList()
    }
    
    private func buildCocktailList() {
        let cocktailList = cocktailListBuilder.build(withListener: interactor)
        cocktailListRouting = cocktailList
        viewController.addViewController(cocktailList.viewControllable, type: .list)
    }
    
    func routeToCocktailList() {
        if let routing = cocktailListRouting {
            attachChild(routing)
            viewController.moveToViewController(type: .list)
        }
    }
    
}
