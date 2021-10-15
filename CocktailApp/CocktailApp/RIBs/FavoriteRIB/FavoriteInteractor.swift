//
//  FavoriteInteractor.swift
//  CocktailApp
//
//

import RIBs
import RxSwift

protocol FavoriteRouting: ViewableRouting {
}

protocol FavoritePresentable: Presentable {
    var listener: FavoritePresentableListener? { get set }
}

protocol FavoriteListener: AnyObject {
}

final class FavoriteInteractor: PresentableInteractor<FavoritePresentable>, FavoriteInteractable, FavoritePresentableListener {

    weak var router: FavoriteRouting?
    weak var listener: FavoriteListener?

    override init(presenter: FavoritePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
}
