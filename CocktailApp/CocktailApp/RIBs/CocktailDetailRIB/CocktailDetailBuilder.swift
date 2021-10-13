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
    
    override init(dependency: CocktailDetailDependency) {
        super.init(dependency: dependency)
    }
}

protocol CocktailDetailBuildable: Buildable {
    func build(withListener listener: CocktailDetailListener, cocktail: Cocktail) -> CocktailDetailRouting
    func build(withListener listener: CocktailDetailListener, id: String) -> CocktailDetailRouting
}

final class CocktailDetailBuilder: Builder<CocktailDetailDependency>, CocktailDetailBuildable {

    override init(dependency: CocktailDetailDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: CocktailDetailListener, cocktail: Cocktail) -> CocktailDetailRouting {
        let component = CocktailDetailComponent(dependency: dependency)
        let viewController = CocktailDetailViewController()
        let interactor = CocktailDetailInteractor(presenter: viewController,
                                                  repository: component.repository,
                                                  cocktail: cocktail)
        interactor.listener = listener
        return CocktailDetailRouter(interactor: interactor, viewController: viewController)
    }
    
    func build(withListener listener: CocktailDetailListener, id: String) -> CocktailDetailRouting {
        let component = CocktailDetailComponent(dependency: dependency)
        let viewController = CocktailDetailViewController()
        let interactor = CocktailDetailInteractor(presenter: viewController,
                                                  repository: component.repository,
                                                  id: id)
        interactor.listener = listener
        return CocktailDetailRouter(interactor: interactor, viewController: viewController)
    }
}
