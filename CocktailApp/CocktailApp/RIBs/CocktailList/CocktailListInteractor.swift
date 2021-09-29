//
//  CocktailListInteractor.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/23.
//

import RIBs
import RxRelay
import RxSwift

protocol CocktailListRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
    func routeToDetail(cocktail: Cocktail)
    func detachChildRIB()
    
}

protocol CocktailListPresentable: Presentable {
    var listener: CocktailListPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol CocktailListListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class CocktailListInteractor: PresentableInteractor<CocktailListPresentable>, CocktailListInteractable {
    weak var router: CocktailListRouting?
    weak var listener: CocktailListListener?
    
    private let repostiory: CocktailRepository
    
    var listTypeRelay: PublishRelay<ListType> = PublishRelay<ListType>()
    var cocktailListRelay: BehaviorRelay<[Cocktail]> = BehaviorRelay<[Cocktail]>(value: [])

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: CocktailListPresentable, repository: CocktailRepository) {
        self.repostiory = repository
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        
        listTypeRelay
            .withUnretained(self)
            .subscribe(onNext: { obj, type in
                obj.requestCocktailList(type: type)
            })
            .disposeOnDeactivate(interactor: self)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    private func requestCocktailList(type: ListType) {
        repostiory.fetchCocktailList(of: type)
            .bind(to: cocktailListRelay)
            .disposeOnDeactivate(interactor: self)
    }
}

extension CocktailListInteractor: CocktailListPresentableListener {
    func didSelectCocktail(of index: Int) {
        print("cocktail is selected: \(cocktailListRelay.value[index].name)")
        
        router?.routeToDetail(cocktail: cocktailListRelay.value[index])
    }
}

extension CocktailListInteractor: CocktailDetailListener {
    func detachCocktailDetailRIB() {
        router?.detachChildRIB()
    }
}
