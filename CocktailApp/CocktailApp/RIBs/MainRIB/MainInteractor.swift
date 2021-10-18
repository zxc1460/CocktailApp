//
//  MainInteractor.swift
//  CocktailApp
//
//

import RIBs
import RxSwift

protocol MainRouting: ViewableRouting {
    func routeToChild(type: TabItemType)
}

protocol MainPresentable: Presentable {
    var listener: MainPresentableListener? { get set }
    func showFavoriteChangeAlert(name: String, isFavorite: Bool)
}

protocol MainListener: AnyObject {
}

final class MainInteractor: PresentableInteractor<MainPresentable>, MainInteractable {

    weak var router: MainRouting?
    weak var listener: MainListener?
    
    private let repository: CommonRepository

    init(presenter: MainPresentable, repository: CommonRepository) {
        self.repository = repository
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        
        subscribe()
    }
    
    private func subscribe() {
        repository.cocktail.notifyFavoriteChanges()
            .subscribe(with: self, onNext: { owner, cocktail in
                owner.presenter.showFavoriteChangeAlert(name: cocktail.name, isFavorite: cocktail.isFavorite)
            })
            .disposeOnDeactivate(interactor: self)
    }
}

// MARK: - PresentableListener

extension MainInteractor: MainPresentableListener {
    func didSelectTab(type: TabItemType) {
        router?.routeToChild(type: type)
    }
}
