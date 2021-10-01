//
//  SearchConditionBuilder.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/30.
//

import RIBs

protocol SearchConditionDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
    var repository: CocktailRepository { get }
}

final class SearchConditionComponent: Component<SearchConditionDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
    var repository: CocktailRepository {
        dependency.repository
    }
}

// MARK: - Builder

protocol SearchConditionBuildable: Buildable {
    func build(withListener listener: SearchConditionListener) -> SearchConditionRouting
}

final class SearchConditionBuilder: Builder<SearchConditionDependency>, SearchConditionBuildable {

    override init(dependency: SearchConditionDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SearchConditionListener) -> SearchConditionRouting {
        let component = SearchConditionComponent(dependency: dependency)
        let viewController = SearchConditionViewController()
        let interactor = SearchConditionInteractor(presenter: viewController, repository: component.repository)
        interactor.listener = listener
        return SearchConditionRouter(interactor: interactor, viewController: viewController)
    }
}
