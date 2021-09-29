//
//  CocktailRandomInteractor.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/28.
//

import RIBs
import RxRelay
import RxSwift

protocol CocktailRandomRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
    func routeToDetail(cocktail: Cocktail)
    func detachChildRIB()
}

protocol CocktailRandomPresentable: Presentable {
    var listener: CocktailRandomPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol CocktailRandomListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class CocktailRandomInteractor: PresentableInteractor<CocktailRandomPresentable>, CocktailRandomInteractable {

    weak var router: CocktailRandomRouting?
    weak var listener: CocktailRandomListener?
    
    private let repository: CocktailRepository
    
    var randomListRelay: BehaviorRelay<[Cocktail]> = BehaviorRelay<[Cocktail]>(value: [])

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: CocktailRandomPresentable, repository: CocktailRepository) {
        self.repository = repository
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        
        requestRandomList()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}

extension CocktailRandomInteractor: CocktailDetailListener {
    func detachCocktailDetailRIB() {
        router?.detachChildRIB()
    }
}


extension CocktailRandomInteractor: CocktailRandomPresentableListener {
    func didSelectCocktail(of index: Int) {
        router?.routeToDetail(cocktail: randomListRelay.value[index])
    }
    
    func requestRandomList() {
        repository.fetchCocktailList(of: .random)
            .bind(to: randomListRelay)
            .disposeOnDeactivate(interactor: self)
    }
}
