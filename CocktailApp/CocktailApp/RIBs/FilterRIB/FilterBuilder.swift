//
//  FilterBuilder.swift
//  CocktailApp
//
//

import RIBs

protocol FilterDependency: Dependency {
    var filterViewController: FilterViewControllable { get }
    var repository: CommonRepository { get }
}

final class FilterComponent: Component<FilterDependency> {
    fileprivate var filterViewController: FilterViewControllable {
        return dependency.filterViewController
    }
    
    var repository: CommonRepository {
        return dependency.repository
    }
}

// MARK: - Builder

protocol FilterBuildable: Buildable {
    func build(withListener listener: FilterListener) -> FilterRouting
}

final class FilterBuilder: Builder<FilterDependency>, FilterBuildable {

    override init(dependency: FilterDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: FilterListener) -> FilterRouting {
        let component = FilterComponent(dependency: dependency)
        let interactor = FilterInteractor(repository: component.repository)
        interactor.listener = listener
        return FilterRouter(interactor: interactor, viewController: component.filterViewController)
    }
}
