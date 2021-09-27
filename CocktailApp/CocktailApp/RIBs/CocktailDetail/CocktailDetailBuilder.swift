//
//  CocktailDetailBuilder.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/27.
//

import RIBs

protocol CocktailDetailDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
    var repository: CocktailRepository { get }
    
}

final class CocktailDetailComponent: Component<CocktailDetailDependency> {
    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
    var repository: CocktailRepository {
        dependency.repository
    }
    
    fileprivate var cocktail: Cocktail
    
    init(dependency: CocktailDetailDependency, cocktail: Cocktail) {
        self.cocktail = cocktail
        
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol CocktailDetailBuildable: Buildable {
    func build(withListener listener: CocktailDetailListener, cocktail: Cocktail) -> CocktailDetailRouting
}

final class CocktailDetailBuilder: Builder<CocktailDetailDependency>, CocktailDetailBuildable {

    override init(dependency: CocktailDetailDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: CocktailDetailListener, cocktail: Cocktail) -> CocktailDetailRouting {
        let component = CocktailDetailComponent(dependency: dependency, cocktail: cocktail)
        let viewController = CocktailDetailViewController()
        let interactor = CocktailDetailInteractor(presenter: viewController,
                                                  repository: component.repository,
                                                  cocktail: component.cocktail)
        interactor.listener = listener
        return CocktailDetailRouter(interactor: interactor, viewController: viewController)
    }
}
