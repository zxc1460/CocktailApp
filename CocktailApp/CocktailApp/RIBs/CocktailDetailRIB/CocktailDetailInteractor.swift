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
    
    private let repository: CommonRepository
    
    private var id: String?
    
    var cocktailRelay: BehaviorRelay<CocktailData?> = BehaviorRelay<CocktailData?>(value: nil)
    
    // MARK: - init Methods
    
    init(presenter: CocktailDetailPresentable, repository: CommonRepository) {
        self.repository = repository
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    convenience init(
        presenter: CocktailDetailPresentable,
        repository: CommonRepository,
        cocktail: CocktailData
    ) {
        self.init(presenter: presenter, repository: repository)
        self.cocktailRelay.accept(cocktail)
    }
    
    convenience init(
        presenter: CocktailDetailPresentable,
        repository: CommonRepository,
        id: String
    ) {
        self.init(presenter: presenter, repository: repository)
        self.id = id
    }
    
    // MARK: - Life Cycle Methods
    
    override func didBecomeActive() {
        super.didBecomeActive()
        
        fetchCocktailDetail()
    }
    
    // MARK: - private Methods
    
    private func fetchCocktailDetail() {
        guard let id = id else { return }
        
        repository.cocktail.loadCocktail(id: id)
            .bind(to: cocktailRelay)
            .disposeOnDeactivate(interactor: self)
    }
}

// MARK: - PresentableListener

extension CocktailDetailInteractor: CocktailDetailPresentableListener {
    func refreshCocktail() {
        guard let cocktail = cocktailRelay.value else { return }
        repository.cocktail.loadCocktail(id: cocktail.id)
            .compactMap { $0 }
            .bind(to: cocktailRelay)
            .disposeOnDeactivate(interactor: self)
    }
    
    func didPopViewController() {
        listener?.detachDetail()
    }
    
    func toggleFavorite() {
        guard let cocktail = cocktailRelay.value else { return }
        
        repository.cocktail.updateCocktail(data: cocktail, isFavorite: !cocktail.isFavorite)
    }
}
