//
//  CocktailDetailInteractor.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/27.
//

import RIBs
import RxCocoa
import RxSwift

protocol CocktailDetailRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CocktailDetailPresentable: Presentable {
    var listener: CocktailDetailPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol CocktailDetailListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func popCocktailDetailRIB()
}

final class CocktailDetailInteractor: PresentableInteractor<CocktailDetailPresentable>, CocktailDetailInteractable {

    weak var router: CocktailDetailRouting?
    weak var listener: CocktailDetailListener?
    
    private let cocktail: Cocktail
    private let repository: CocktailRepository
    let disposeBag = DisposeBag()
    
    lazy var cocktailDetail: BehaviorRelay<Cocktail> = BehaviorRelay<Cocktail>(value: cocktail)

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: CocktailDetailPresentable, repository: CocktailRepository, cocktail: Cocktail) {
        self.cocktail = cocktail
        self.repository = repository
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}

extension CocktailDetailInteractor: CocktailDetailPresentableListener {
    func refreshCocktail() {
        repository.fetchDetail(id: cocktail.id)
            .compactMap { $0 }
            .bind(to: cocktailDetail)
            .disposed(by: disposeBag)
    }
    
    func backButtonDidTap() {
        listener?.popCocktailDetailRIB()
    }
}
