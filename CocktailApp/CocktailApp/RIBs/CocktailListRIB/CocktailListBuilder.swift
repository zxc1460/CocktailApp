//
//  CocktailListBuilder.swift
//  CocktailApp
//
//

import RIBs

protocol CocktailListDependency: Dependency {
    var repository: CommonRepository { get }
}

final class CocktailListComponent: Component<CocktailListDependency> {
    var repository: CommonRepository {
        dependency.repository
    }
}

protocol CocktailListBuildable: Buildable {
    func build(withListener listener: CocktailListListener) -> CocktailListRouting
}

final class CocktailListBuilder: Builder<CocktailListDependency>, CocktailListBuildable {

    override init(dependency: CocktailListDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: CocktailListListener) -> CocktailListRouting {
        let component = CocktailListComponent(dependency: dependency)
        let viewController = CocktailListViewController()
        let interactor = CocktailListInteractor(presenter: viewController, repository: component.repository)
        let cocktailDetailBuilder = CocktailDetailBuilder(dependency: component)
        interactor.listener = listener
        return CocktailListRouter(
            interactor: interactor,
            viewController: viewController,
            cocktailDetailBuilder: cocktailDetailBuilder
        )
    }
}
