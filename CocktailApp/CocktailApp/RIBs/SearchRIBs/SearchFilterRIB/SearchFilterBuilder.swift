//
//  SearchFilterBuilder.swift
//  CocktailApp
//
//

import RIBs

protocol SearchFilterDependency: Dependency {
    var repository: CommonRepository { get }
}

final class SearchFilterComponent: Component<SearchFilterDependency> {
    var repository: CommonRepository {
        dependency.repository
    }
}

// MARK: - Builder

protocol SearchFilterBuildable: Buildable {
    func build(withListener listener: SearchFilterListener) -> SearchFilterRouting
}

final class SearchFilterBuilder: Builder<SearchFilterDependency>, SearchFilterBuildable {

    override init(dependency: SearchFilterDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SearchFilterListener) -> SearchFilterRouting {
        let component = SearchFilterComponent(dependency: dependency)
        let viewController = SearchFilterViewController()
        let interactor = SearchFilterInteractor(presenter: viewController, repository: component.repository)
        interactor.listener = listener
        return SearchFilterRouter(interactor: interactor, viewController: viewController)
    }
}
