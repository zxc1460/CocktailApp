//
//  CocktailRandomBuilder.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/28.
//

import RIBs

protocol CocktailRandomDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class CocktailRandomComponent: Component<CocktailRandomDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
    var repository: CocktailRepository
    
    init(dependency: CocktailRandomDependency, repository: CocktailRepository) {
        self.repository = repository
        
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol CocktailRandomBuildable: Buildable {
    func build(withListener listener: CocktailRandomListener, repository: CocktailRepository) -> CocktailRandomRouting
}

final class CocktailRandomBuilder: Builder<CocktailRandomDependency>, CocktailRandomBuildable {

    override init(dependency: CocktailRandomDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: CocktailRandomListener, repository: CocktailRepository) -> CocktailRandomRouting {
        let component = CocktailRandomComponent(dependency: dependency, repository: repository)
        let viewController = CocktailRandomViewController()
        let interactor = CocktailRandomInteractor(presenter: viewController, repository: repository)
        let cocktailDetailBuilder = CocktailDetailBuilder(dependency: component)
        interactor.listener = listener
        return CocktailRandomRouter(interactor: interactor,
                                    viewController: viewController,
                                    cocktailDetailBuilder: cocktailDetailBuilder)
    }
}
