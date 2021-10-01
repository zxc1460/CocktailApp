//
//  SearchNameBuilder.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/30.
//

import RIBs

protocol SearchNameDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
    var repository: CocktailRepository { get }
}

final class SearchNameComponent: Component<SearchNameDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
    var repository: CocktailRepository {
        dependency.repository
    }
}

// MARK: - Builder

protocol SearchNameBuildable: Buildable {
    func build(withListener listener: SearchNameListener) -> SearchNameRouting
}

final class SearchNameBuilder: Builder<SearchNameDependency>, SearchNameBuildable {

    override init(dependency: SearchNameDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SearchNameListener) -> SearchNameRouting {
        let component = SearchNameComponent(dependency: dependency)
        let viewController = SearchNameViewController()
        let interactor = SearchNameInteractor(presenter: viewController, repository: component.repository)
        interactor.listener = listener
        return SearchNameRouter(interactor: interactor, viewController: viewController)
    }
}
