//
//  MainRouter.swift
//  CocktailApp
//
//

import RIBs

protocol MainInteractable: Interactable, CocktailListListener, SearchPageListener, FavoriteListener {
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
    
    private let favoriteBuilder: FavoriteBuildable
    private var favoriteRouting: FavoriteRouting?
    
    init(interactor: MainInteractable,
        viewController: MainViewControllable,
        cocktailListBuilder: CocktailListBuildable,
        searchPageBuilder: SearchPageBuildable,
         favoriteBuilder: FavoriteBuildable) {
        self.cocktailListBuilder = cocktailListBuilder
        self.searchPageBuilder = searchPageBuilder
        self.favoriteBuilder = favoriteBuilder
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
        
        let favoriteRouting = favoriteBuilder.build(withListener: interactor)
        self.favoriteRouting = favoriteRouting
        viewController.addViewController(favoriteRouting.viewControllable, type: .favorite)
    }
}

extension MainRouter: MainRouting {
    func routeToChild(type: TabItemType) {
        detachChildren()
        
        let routings = [cocktailListRouting, searchPageRouting, favoriteRouting]
        
        if let routing = routings[type.rawValue] {
            attachChild(routing)
        }
    }
}
