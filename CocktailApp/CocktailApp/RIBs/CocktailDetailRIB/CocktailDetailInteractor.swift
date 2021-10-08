//
//  CocktailDetailInteractor.swift
//  CocktailApp
//
// 

import RIBs
import RxRelay
import RxSwift

protocol CocktailDetailRouting: ViewableRouting {
}

protocol CocktailDetailPresentable: Presentable {
    var listener: CocktailDetailPresentableListener? { get set }
}

protocol CocktailDetailListener: AnyObject {
    func detachDetail()
}

final class CocktailDetailInteractor: PresentableInteractor<CocktailDetailPresentable>, CocktailDetailInteractable {
    
    // MARK: - Properties

    weak var router: CocktailDetailRouting?
    weak var listener: CocktailDetailListener?
    
    private let cocktail: Cocktail
    private let repository: CommonRepository
    
    lazy var cocktailRelay: BehaviorRelay<Cocktail> = BehaviorRelay<Cocktail>(value: cocktail)

    init(presenter: CocktailDetailPresentable,
         repository: CommonRepository,
         cocktail: Cocktail) {
        self.cocktail = cocktail
        self.repository = repository
        super.init(presenter: presenter)
        presenter.listener = self
    }
}

// MARK: - PresentableListener

extension CocktailDetailInteractor: CocktailDetailPresentableListener {
    func refreshCocktail() {
        repository.cocktail.fetchCocktailDetail(from: cocktail.id)
            .compactMap { $0 }
            .bind(to: cocktailRelay)
            .disposeOnDeactivate(interactor: self)
    }
    
    func didPopViewController() {
        listener?.detachDetail()
    }
}
