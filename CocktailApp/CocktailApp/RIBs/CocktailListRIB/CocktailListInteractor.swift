//
//  CocktailListInteractor.swift
//  CocktailApp
//
// 

import RIBs
import RxRelay
import RxSwift

protocol CocktailListRouting: ViewableRouting {
    func routeToDetail(cocktail: CocktailData)
    func detachChildRIB()
    
}

protocol CocktailListPresentable: Presentable {
    var listener: CocktailListPresentableListener? { get set }
}

protocol CocktailListListener: AnyObject {
}

final class CocktailListInteractor: PresentableInteractor<CocktailListPresentable>, CocktailListInteractable {
    
    // MARK: - Properties
    
    weak var router: CocktailListRouting?
    weak var listener: CocktailListListener?
    
    private let repository: CommonRepository
    
    var cocktailListRelay: BehaviorRelay<[CocktailData]> = BehaviorRelay<[CocktailData]>(value: [])

    init(presenter: CocktailListPresentable, repository: CommonRepository) {
        self.repository = repository
        super.init(presenter: presenter)
        presenter.listener = self
    }
}

// MARK: - PresentableListener

extension CocktailListInteractor: CocktailListPresentableListener {
    func didSelectCocktail(of index: Int) {
        router?.routeToDetail(cocktail: cocktailListRelay.value[index])
    }
    
    func requestCocktailList(type: ListType) {
        repository.cocktail.loadCocktailList(type: type)
            .asObservable()
            .bind(to: cocktailListRelay)
            .disposeOnDeactivate(interactor: self)
    }
    
    func favoriteValueChanged(of cocktail: CocktailData, value: Bool) {
        repository.cocktail.updateCocktail(data: cocktail, isFavorite: value)
    }
    
}

// MARK: - CocktailDetailListener

extension CocktailListInteractor: CocktailDetailListener {
    func detachDetail() {
        router?.detachChildRIB()
    }
}
