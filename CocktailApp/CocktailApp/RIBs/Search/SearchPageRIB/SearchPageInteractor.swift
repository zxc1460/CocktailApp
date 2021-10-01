//
//  SearchPageInteractor.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/30.
//

import RIBs
import RxSwift

protocol SearchPageRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
    func showChild(type: SearchType)
    func selectChild(type: SearchType) -> ViewControllable?
}

protocol SearchPagePresentable: Presentable {
    var listener: SearchPagePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol SearchPageListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class SearchPageInteractor: PresentableInteractor<SearchPagePresentable>, SearchPageInteractable {

    weak var router: SearchPageRouting?
    weak var listener: SearchPageListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: SearchPagePresentable) {
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

extension SearchPageInteractor: SearchPagePresentableListener {    
    func didSelectPage(type: SearchType) {
        router?.showChild(type: type)
    }
    
    func scrollTo(direction: PageDirection) -> ViewControllable? {
        guard let type = SearchType(rawValue: direction.rawValue) else {
            return nil
        }
        
        return router?.selectChild(type: type)
    }
}

enum SearchType: Int {
    case name
    case condition
}
