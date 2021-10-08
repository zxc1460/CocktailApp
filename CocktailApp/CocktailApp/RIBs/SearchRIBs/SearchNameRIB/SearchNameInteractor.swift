//
//  SearchNameInteractor.swift
//  CocktailApp
//
//

import RIBs
import RxRelay
import RxSwift

protocol SearchNameRouting: ViewableRouting {
    func routeToDetail(cocktail: Cocktail)
    func detachDetail()
}

protocol SearchNamePresentable: Presentable {
    var listener: SearchNamePresentableListener? { get set }
}

protocol SearchNameListener: AnyObject {
}

final class SearchNameInteractor: PresentableInteractor<SearchNamePresentable>, SearchNameInteractable {
    
    // MARK: - Properties

    weak var router: SearchNameRouting?
    weak var listener: SearchNameListener?
    
    private let repository: CommonRepository
    
    var searchResultRelay: BehaviorRelay<[Cocktail]> = BehaviorRelay<[Cocktail]>(value: [])
    
    // MARK: - init Method
    
    init(presenter: SearchNamePresentable, repository: CommonRepository) {
        self.repository = repository
        super.init(presenter: presenter)
        presenter.listener = self
    }
}

// MARK: - PresentableListener

extension SearchNameInteractor: SearchNamePresentableListener {
    func searchCocktailList(name: String) {
        repository.cocktail.searchCocktail(name: name)
            .bind(to: searchResultRelay)
            .disposeOnDeactivate(interactor: self)
    }
    
    func didSelectCocktail(of index: Int) {
        router?.routeToDetail(cocktail: searchResultRelay.value[index])
    }
}

// MARK: - CocktailDetailListener

extension SearchNameInteractor: CocktailDetailListener {
    func detachDetail() {
        router?.detachDetail()
    }
}
