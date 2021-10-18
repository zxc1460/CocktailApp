//
//  FavoriteInteractor.swift
//  CocktailApp
//
//

import RealmSwift
import RIBs
import RxRealm
import RxRelay
import RxSwift

protocol FavoriteRouting: ViewableRouting {
    func routeToDetail(cocktail: CocktailData)
    func detachChildRIB()
}

protocol FavoritePresentable: Presentable {
    var listener: FavoritePresentableListener? { get set }
}

protocol FavoriteListener: AnyObject {
}

final class FavoriteInteractor: PresentableInteractor<FavoritePresentable>, FavoriteInteractable {

    weak var router: FavoriteRouting?
    weak var listener: FavoriteListener?
    
    private let repository: CommonRepository
    
    var favoriteListRelay: BehaviorRelay<[CocktailData]> = BehaviorRelay<[CocktailData]>(value: [])

    init(presenter: FavoritePresentable, repository: CommonRepository) {
        self.repository = repository
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        bind()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    private func bind() {
        repository.cocktail.loadFavoriteList()
            .bind(to: favoriteListRelay)
            .disposeOnDeactivate(interactor: self)
    }
}

extension FavoriteInteractor: FavoritePresentableListener {
    func deleteFavorite(cocktail: CocktailData) {
        repository.cocktail.updateCocktail(data: cocktail, isFavorite: false)
    }
    
    func didSelectCocktail(of index: Int) {
        router?.routeToDetail(cocktail: favoriteListRelay.value[index])
    }
}

extension FavoriteInteractor: CocktailDetailListener {
    func detachDetail() {
        router?.detachChildRIB()
    }
}
