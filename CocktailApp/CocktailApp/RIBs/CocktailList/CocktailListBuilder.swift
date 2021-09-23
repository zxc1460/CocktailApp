//
//  CocktailListBuilder.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/23.
//

import RIBs

protocol CocktailListDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class CocktailListComponent: Component<CocktailListDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol CocktailListBuildable: Buildable {
    func build(withListener listener: CocktailListListener) -> CocktailListRouting
}

final class CocktailListBuilder: Builder<CocktailListDependency>, CocktailListBuildable {

    override init(dependency: CocktailListDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: CocktailListListener) -> CocktailListRouting {
        let component = CocktailListComponent(dependency: dependency)
        let viewController = CocktailListViewController()
        let interactor = CocktailListInteractor(presenter: viewController)
        interactor.listener = listener
        return CocktailListRouter(interactor: interactor, viewController: viewController)
    }
}
