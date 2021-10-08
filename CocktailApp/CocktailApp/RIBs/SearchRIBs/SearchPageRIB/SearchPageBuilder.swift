//
//  SearchPageBuilder.swift
//  CocktailApp
//
//

import RIBs

protocol SearchPageDependency: Dependency {
    var repository: CommonRepository { get }
}

final class SearchPageComponent: Component<SearchPageDependency> {
    var repository: CommonRepository {
        dependency.repository
    }
}

// MARK: - Builder

protocol SearchPageBuildable: Buildable {
    func build(withListener listener: SearchPageListener) -> SearchPageRouting
}

final class SearchPageBuilder: Builder<SearchPageDependency>, SearchPageBuildable {

    override init(dependency: SearchPageDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SearchPageListener) -> SearchPageRouting {
        let component = SearchPageComponent(dependency: dependency)
        let viewController = SearchPageViewController()
        let interactor = SearchPageInteractor(presenter: viewController)
        let searchNameBuilder = SearchNameBuilder(dependency: component)
        let searchFilterBuilder = SearchFilterBuilder(dependency: component)
        
        interactor.listener = listener
        return SearchPageRouter(interactor: interactor,
                                viewController: viewController,
                                searchNameBuilder: searchNameBuilder,
                                searchFilterBuilder: searchFilterBuilder)
    }
}
