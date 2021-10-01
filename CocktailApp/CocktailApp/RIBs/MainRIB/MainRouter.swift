//
//  MainRouter.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/29.
//

import RIBs

protocol MainInteractable: Interactable, CocktailListListener, SearchPageListener {
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
    
    private let searchPageBuilder: SearchPageBuildable
    private var searchPageRouting: SearchPageRouting?
    
    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: MainInteractable,
        viewController: MainViewControllable,
        cocktailListBuilder: CocktailListBuildable,
        searchPageBuilder: SearchPageBuildable) {
        self.cocktailListBuilder = cocktailListBuilder
        self.searchPageBuilder = searchPageBuilder
        
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
        
        let cocktailListRouting = cocktailListBuilder.build(withListener: interactor, repository: repository)
        self.cocktailListRouting = cocktailListRouting
        viewController.addViewController(cocktailListRouting.viewControllable, type: .list)
        
        let searchPageRouting = searchPageBuilder.build(withListener: interactor, repository: repository)
        self.searchPageRouting = searchPageRouting
        viewController.addViewController(searchPageRouting.viewControllable, type: .search)
    }
}

extension MainRouter: MainRouting {
    func routeToChild(type: TabItemType) {
        detachChildren()
        
        let routings = [cocktailListRouting, searchPageRouting]
        
        if let routing = routings[type.rawValue] {
            attachChild(routing)
        }
    }
}
