//
//  CocktailDetailBuilder.swift
//  CocktailApp
//
//

import RIBs

protocol CocktailDetailDependency: Dependency {
    var repository: CommonRepository { get }
}

final class CocktailDetailComponent: Component<CocktailDetailDependency> {
    var repository: CommonRepository {
        dependency.repository
    }
    
    fileprivate var cocktail: Cocktail
    
    init(dependency: CocktailDetailDependency, cocktail: Cocktail) {
        self.cocktail = cocktail
        
        super.init(dependency: dependency)
    }
}

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
