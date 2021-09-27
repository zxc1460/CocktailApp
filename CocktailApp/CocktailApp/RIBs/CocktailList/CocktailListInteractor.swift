//
//  CocktailListInteractor.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/23.
//

import RIBs
import RxSwift
import RxCocoa

protocol CocktailListRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
    func routeToDetail(cocktail: Cocktail)
    func popFromChild()
    
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
    
    var typeInput: PublishRelay<ListType> = PublishRelay<ListType>()
    var cocktails: BehaviorRelay<[Cocktail]> = BehaviorRelay<[Cocktail]>(value: [])
    let disposeBag = DisposeBag()

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: CocktailListPresentable, repository: CocktailRepository) {
        self.repostiory = repository
        super.init(presenter: presenter)
        presenter.listener = self
        
        typeInput
            .subscribe(onNext: { [weak self] type in
                self?.fetchCocktails(type: type)
            })
            .disposed(by: disposeBag)
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    private func fetchCocktails(type: ListType) {
        repostiory.fetchCocktails(type: type)
            .bind(to: cocktails)
            .disposed(by: disposeBag)
    }
}

extension CocktailListInteractor: CocktailListPresentableListener {
    func selectCocktail(index: Int) {
        print("cocktail is selected: \(cocktails.value[index].name)")
        
        router?.routeToDetail(cocktail: cocktails.value[index])
    }
}

extension CocktailListInteractor: CocktailDetailListener {
    func popCocktailDetailRIB() {
        router?.popFromChild()
    }
}
