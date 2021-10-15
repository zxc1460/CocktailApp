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
    
    var isLoadingRelay: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    var cocktailRelay: BehaviorRelay<CocktailData?> = BehaviorRelay<CocktailData?>(value: nil)
    
    init(presenter: CocktailDetailPresentable,
         repository: CommonRepository) {
        self.repository = repository
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    convenience init(presenter: CocktailDetailPresentable,
                     repository: CommonRepository,
                     cocktail: CocktailData) {
        self.init(presenter: presenter, repository: repository)
        self.cocktailRelay.accept(cocktail)
    }
    
    convenience init(presenter: CocktailDetailPresentable,
                     repository: CommonRepository,
                     id: String) {
        self.init(presenter: presenter, repository: repository)
        self.id = id
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        
        fetchCocktailDetail()
        bind()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
    private func fetchCocktailDetail() {
        guard let id = id else {
            return
        }
        
        self.isLoadingRelay.accept(true)
        repository.cocktail.loadCocktailDetail(from: id)
            .subscribe(with: self,
                       onNext: { owner, cocktail in
                owner.cocktailRelay.accept(cocktail)
            }, onCompleted: { owner in
                owner.isLoadingRelay.accept(false)
            })
            .disposeOnDeactivate(interactor: self)
    }
    
    private func bind() {
        guard let cocktail = cocktailRelay.value else { return }
        
        Observable.from(object: cocktail, properties: ["isFavorite"])
            .bind(to: cocktailRelay)
            .disposeOnDeactivate(interactor: self)
    }
    
    func toggleFavorite() {
        guard let cocktail = cocktailRelay.value else { return }
        
        repository.cocktail.updateCocktailData(data: cocktail, isFavorite: !cocktail.isFavorite)
    }
}

// MARK: - PresentableListener

extension CocktailDetailInteractor: CocktailDetailPresentableListener {
    func refreshCocktail() {
        guard let cocktail = cocktailRelay.value else {
            return
        }
        repository.cocktail.loadCocktailDetail(from: cocktail.id)
            .compactMap { $0 }
            .bind(to: cocktailRelay)
            .disposeOnDeactivate(interactor: self)
    }
    
    func didPopViewController() {
        listener?.detachDetail()
    }
}
