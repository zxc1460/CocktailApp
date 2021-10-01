//
//  SearchNameInteractor.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/30.
//

import RIBs
import RxSwift

protocol SearchNameRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SearchNamePresentable: Presentable {
    var listener: SearchNamePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol SearchNameListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class SearchNameInteractor: PresentableInteractor<SearchNamePresentable>, SearchNameInteractable, SearchNamePresentableListener {

    weak var router: SearchNameRouting?
    weak var listener: SearchNameListener?
    
    private let repository: CocktailRepository

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: SearchNamePresentable, repository: CocktailRepository) {
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
