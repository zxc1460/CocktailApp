//
//  SearchFilterInteractor.swift
//  CocktailApp
//
//

import RIBs
import RxCocoa
import RxSwift

protocol SearchFilterRouting: ViewableRouting {
    func attachFilter()
    func routeToDetail(id: String)
    func detachDetail()
}

protocol SearchFilterPresentable: Presentable {
    var listener: SearchFilterPresentableListener? { get set }
}

protocol SearchFilterListener: AnyObject {
}

final class SearchFilterInteractor: PresentableInteractor<SearchFilterPresentable>, SearchFilterInteractable {

    weak var router: SearchFilterRouting?
    weak var listener: SearchFilterListener?
    
    private let repository: CommonRepository
    
    // MARK: - Relays
    
    var isLoadingRelay: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    var filterTypeRelay: PublishRelay<FilterType> = PublishRelay<FilterType>()
    var filterKeywordsRelay: BehaviorRelay<[String]> = BehaviorRelay<[String]>(value: [])
    var cocktailListRelay: BehaviorRelay<[CocktailSnippet]> = BehaviorRelay<[CocktailSnippet]>(value: [])

    init(presenter: SearchFilterPresentable, repository: CommonRepository) {
        self.repository = repository
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        router?.attachFilter()
    }
}

// MARK: - PresentableListener

extension SearchFilterInteractor: SearchFilterPresentableListener {
    func searchCocktail(type: FilterType, keyword: String) {
        repository.cocktail.searchCocktail(type: type, keyword: keyword)
            .bind(to: cocktailListRelay)
            .disposeOnDeactivate(interactor: self)
    }
    
    func didSelectCocktail(of index: Int) {
        let id = cocktailListRelay.value[index].id
        router?.routeToDetail(id: id)
    }
}

// MARK: - CocktailDetailListener

extension SearchFilterInteractor: CocktailDetailListener {
    func detachDetail() {
        router?.detachDetail()
    }
}
