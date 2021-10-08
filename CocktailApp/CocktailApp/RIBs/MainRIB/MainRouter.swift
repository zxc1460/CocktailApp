//
//  MainRouter.swift
//  CocktailApp
//
//

import RIBs

protocol MainInteractable: Interactable, CocktailListListener, SearchPageListener {
    var router: MainRouting? { get set }
    var listener: MainListener? { get set }
}

protocol MainViewControllable: ViewControllable {
    func addViewController(_ viewControllable: ViewControllable, type: TabItemType)
}

final class MainRouter: ViewableRouter<MainInteractable, MainViewControllable> {
    private let cocktailListBuilder: CocktailListBuildable
    private var cocktailListRouting: CocktailListRouting?
    
    private let searchPageBuilder: SearchPageBuildable
    private var searchPageRouting: SearchPageRouting?
    
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
        let cocktailListRouting = cocktailListBuilder.build(withListener: interactor)
        self.cocktailListRouting = cocktailListRouting
        viewController.addViewController(cocktailListRouting.viewControllable, type: .list)
        
        let searchPageRouting = searchPageBuilder.build(withListener: interactor)
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
