//
//  FavoriteBuilder.swift
//  CocktailApp
//
//

import RIBs

protocol FavoriteDependency: Dependency {
    var repository: CommonRepository { get }
}

final class FavoriteComponent: Component<FavoriteDependency> {
    var repository: CommonRepository {
        return dependency.repository
    }
}

// MARK: - Builder

protocol FavoriteBuildable: Buildable {
    func build(withListener listener: FavoriteListener) -> FavoriteRouting
}

final class FavoriteBuilder: Builder<FavoriteDependency>, FavoriteBuildable {

    override init(dependency: FavoriteDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: FavoriteListener) -> FavoriteRouting {
        let component = FavoriteComponent(dependency: dependency)
        let viewController = FavoriteViewController()
        let interactor = FavoriteInteractor(presenter: viewController)
        interactor.listener = listener
        return FavoriteRouter(interactor: interactor, viewController: viewController)
    }
}
