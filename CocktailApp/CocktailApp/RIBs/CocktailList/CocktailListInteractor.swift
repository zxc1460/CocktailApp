//
//  CocktailListInteractor.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/23.
//

import RIBs
import RxSwift

protocol CocktailListRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
    
}

protocol CocktailListPresentable: Presentable {
    var listener: CocktailListPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol CocktailListListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class CocktailListInteractor: PresentableInteractor<CocktailListPresentable>, CocktailListInteractable, CocktailListPresentableListener {

    weak var router: CocktailListRouting?
    weak var listener: CocktailListListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: CocktailListPresentable) {
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
