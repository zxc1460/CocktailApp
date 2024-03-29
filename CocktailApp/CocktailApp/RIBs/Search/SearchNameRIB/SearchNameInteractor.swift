//
//  SearchNameInteractor.swift
//  CocktailApp
//
//

import RIBs
import RxRelay
import RxSwift

protocol SearchNameRouting: ViewableRouting {
    func routeToDetail(cocktail: CocktailData)
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
    
    var searchResultRelay: BehaviorRelay<[CocktailData]> = BehaviorRelay<[CocktailData]>(value: [])
    
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
        repository.cocktail.searchCocktailList(name: name)
            .bind(to: searchResultRelay)
            .disposeOnDeactivate(interactor: self)
    }
    
    func didSelectCocktail(of index: Int) {
        router?.routeToDetail(cocktail: searchResultRelay.value[index])
    }
    
    func favoriteValueChanged(of cocktail: CocktailData, value: Bool) {
        repository.cocktail.updateCocktail(data: cocktail, isFavorite: value)
    }
}

// MARK: - CocktailDetailListener

extension SearchNameInteractor: CocktailDetailListener {
    func detachDetail() {
        router?.detachDetail()
    }
}
