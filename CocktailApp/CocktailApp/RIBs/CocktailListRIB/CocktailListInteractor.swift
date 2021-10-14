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
    
    private let repostiory: CommonRepository
    
    var cocktailListRelay: BehaviorRelay<[CocktailData]> = BehaviorRelay<[CocktailData]>(value: [])

    init(presenter: CocktailListPresentable, repository: CommonRepository) {
        self.repostiory = repository
        super.init(presenter: presenter)
        presenter.listener = self
    }
}

// MARK: - PresentableListener

extension CocktailListInteractor: CocktailListPresentableListener {
    func didSelectCocktail(of index: Int) {
        print("cocktail is selected: \(cocktailListRelay.value[index].name)")
        
        router?.routeToDetail(cocktail: cocktailListRelay.value[index])
    }
    
    func requestCocktailList(type: ListType) {
        repostiory.cocktail.loadCocktailList(of: type)
            .asObservable()
            .debug()
            .bind(to: cocktailListRelay)
            .disposeOnDeactivate(interactor: self)
    }
    
}

// MARK: - CocktailDetailListener

extension CocktailListInteractor: CocktailDetailListener {
    func detachDetail() {
        router?.detachChildRIB()
    }
}
