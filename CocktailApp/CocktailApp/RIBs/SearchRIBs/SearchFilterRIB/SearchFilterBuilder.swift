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
    
    let searchFilterViewController: SearchFilterViewController
    
    init(dependency: SearchFilterDependency,
         searchFilterViewController: SearchFilterViewController) {
        self.searchFilterViewController = searchFilterViewController
        super.init(dependency: dependency)
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
        let viewController = SearchFilterViewController()
        let component = SearchFilterComponent(dependency: dependency, searchFilterViewController: viewController)
        let interactor = SearchFilterInteractor(presenter: viewController, repository: component.repository)
        let filterBuilder = FilterBuilder(dependency: component)
        let cocktailDetailBuilder = CocktailDetailBuilder(dependency: component)
        interactor.listener = listener
        return SearchFilterRouter(interactor: interactor,
                                  viewController: viewController,
                                  filterBuilder: filterBuilder,
                                  cocktailDetailBuilder: cocktailDetailBuilder)
    }
}
