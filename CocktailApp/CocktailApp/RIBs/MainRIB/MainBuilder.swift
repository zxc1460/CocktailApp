//
//  MainBuilder.swift
//  CocktailApp
//
//

import RIBs

protocol MainDependency: Dependency {
}

final class MainComponent: Component<MainDependency> {
    var repository: CommonRepository
    
    init(dependency: MainDependency, repository: CommonRepository) {
        self.repository = repository
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol MainBuildable: Buildable {
    func build(withListener listener: MainListener, repository: CommonRepository) -> MainRouting
}

final class MainBuilder: Builder<MainDependency>, MainBuildable {

    override init(dependency: MainDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: MainListener, repository: CommonRepository) -> MainRouting {
        let component = MainComponent(dependency: dependency, repository: repository)
        let viewController = MainViewController()
        let interactor = MainInteractor(presenter: viewController, repository: repository)
        let cocktailListBuilder = CocktailListBuilder(dependency: component)
        let searchPageBuilder = SearchPageBuilder(dependency: component)
        let favoriteBuilder = FavoriteBuilder(dependency: component)
        
        interactor.listener = listener
        
        return MainRouter(interactor: interactor,
                          viewController: viewController,
                          cocktailListBuilder: cocktailListBuilder,
                          searchPageBuilder: searchPageBuilder,
                          favoriteBuilder: favoriteBuilder)
    }
}
