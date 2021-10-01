//
//  MainBuilder.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/29.
//

import RIBs

protocol MainDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class MainComponent: Component<MainDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol MainBuildable: Buildable {
    func build(withListener listener: MainListener) -> MainRouting
}

final class MainBuilder: Builder<MainDependency>, MainBuildable {

    override init(dependency: MainDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: MainListener) -> MainRouting {
        let component = MainComponent(dependency: dependency)
        let viewController = MainViewController()
        let interactor = MainInteractor(presenter: viewController)
        let cocktailListBuilder = CocktailListBuilder(dependency: component)
        let searchPageBuilder = SearchPageBuilder(dependency: component)
        
        interactor.listener = listener
        
        return MainRouter(interactor: interactor,
                          viewController: viewController,
                          cocktailListBuilder: cocktailListBuilder,
                          searchPageBuilder: searchPageBuilder)
    }
}
