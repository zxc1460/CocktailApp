//
//  MainRouter.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/29.
//

import RIBs

protocol MainInteractable: Interactable, CocktailListListener, CocktailRandomListener {
    var router: MainRouting? { get set }
    var listener: MainListener? { get set }
}

protocol MainViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func addViewController(_ viewControllable: ViewControllable, type: TabItemType)
}

final class MainRouter: ViewableRouter<MainInteractable, MainViewControllable> {

    // TODO: Constructor inject child builder protocols to allow building children.
    private let cocktailListBuilder: CocktailListBuildable
    private var cocktailListRouting: CocktailListRouting?

    private let cocktailRandomBuilder: CocktailRandomBuildable
    private var cocktailRandomRouting: CocktailRandomRouting?
    
    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: MainInteractable,
        viewController: MainViewControllable,
        cocktailListBuilder: CocktailListBuildable,
        cocktailRandomBuilder: CocktailRandomBuildable) {
        self.cocktailListBuilder = cocktailListBuilder
        self.cocktailRandomBuilder = cocktailRandomBuilder
        
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    override func didLoad() {
        super.didLoad()
        buildChildRIBs()
        routeToChild(type: .list)
    }
    
    private func buildChildRIBs() {
        let repository = CocktailRepository()
        
        let cocktailListRouter = cocktailListBuilder.build(withListener: interactor, repository: repository)
        cocktailListRouting = cocktailListRouter
        viewController.addViewController(cocktailListRouter.viewControllable, type: .list)
        
        let cocktailRandomRouter = cocktailRandomBuilder.build(withListener: interactor, repository: repository)
        cocktailRandomRouting = cocktailRandomRouter
        viewController.addViewController(cocktailRandomRouter.viewControllable, type: .random)
    }
}

extension MainRouter: MainRouting {
    func routeToChild(type: TabItemType) {
        children.forEach {
            detachChild($0)
        }
        
        let routings = [cocktailListRouting, cocktailRandomRouting]
        
        if let routing = routings[type.rawValue] {
            attachChild(routing)
        }
    }
}
