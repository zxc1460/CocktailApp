//
//  SearchNameBuilder.swift
//  CocktailApp
//
//

import RIBs

protocol SearchNameDependency: Dependency {
    var repository: CommonRepository { get }
}

final class SearchNameComponent: Component<SearchNameDependency> {
    var repository: CommonRepository {
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
        let cocktailDetailBuilder = CocktailDetailBuilder(dependency: component)
        interactor.listener = listener
        return SearchNameRouter(interactor: interactor,
                                viewController: viewController,
                                cocktailDetailBuilder: cocktailDetailBuilder)
    }
}
