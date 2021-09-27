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
    
    var repository: CocktailRepository
    
    init(dependency: CocktailListDependency, repository: CocktailRepository) {
        self.repository = repository
        
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol CocktailListBuildable: Buildable {
    func build(withListener listener: CocktailListListener, repository: CocktailRepository) -> CocktailListRouting
}

final class CocktailListBuilder: Builder<CocktailListDependency>, CocktailListBuildable {

    override init(dependency: CocktailListDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: CocktailListListener, repository: CocktailRepository) -> CocktailListRouting {
        let component = CocktailListComponent(dependency: dependency, repository: repository)
        let viewController = CocktailListViewController()
        let interactor = CocktailListInteractor(presenter: viewController, repository: repository)
        let cocktailDetailBuilder = CocktailDetailBuilder(dependency: component)
        interactor.listener = listener
        return CocktailListRouter(interactor: interactor, viewController: viewController, cocktailDetailBuilder: cocktailDetailBuilder)
    }
}
