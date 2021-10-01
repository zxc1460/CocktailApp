//
//  SearchPageBuilder.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/30.
//

import RIBs

protocol SearchPageDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class SearchPageComponent: Component<SearchPageDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
    
    var repository: CocktailRepository
    
    init(dependency: SearchPageDependency, repository: CocktailRepository) {
        self.repository = repository
        
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol SearchPageBuildable: Buildable {
    func build(withListener listener: SearchPageListener,
               repository: CocktailRepository) -> SearchPageRouting
}

final class SearchPageBuilder: Builder<SearchPageDependency>, SearchPageBuildable {

    override init(dependency: SearchPageDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SearchPageListener,
               repository: CocktailRepository) -> SearchPageRouting {
        let component = SearchPageComponent(dependency: dependency, repository: repository)
        let viewController = SearchPageViewController()
        let interactor = SearchPageInteractor(presenter: viewController)
        let searchNameBuilder = SearchNameBuilder(dependency: component)
        let searchConditionBuilder = SearchConditionBuilder(dependency: component)
        
        interactor.listener = listener
        return SearchPageRouter(interactor: interactor,
                                viewController: viewController,
                                searchNameBuilder: searchNameBuilder,
                                searchConditionBuilder: searchConditionBuilder)
    }
}
