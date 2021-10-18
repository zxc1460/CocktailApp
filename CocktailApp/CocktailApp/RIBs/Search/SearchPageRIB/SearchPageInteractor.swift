//
//  SearchPageInteractor.swift
//  CocktailApp
//
//

import RIBs
import RxSwift

protocol SearchPageRouting: ViewableRouting {
    func showChild(type: SearchType)
    func selectChild(type: SearchType) -> ViewControllable?
}

protocol SearchPagePresentable: Presentable {
    var listener: SearchPagePresentableListener? { get set }
}

protocol SearchPageListener: AnyObject {
}

final class SearchPageInteractor: PresentableInteractor<SearchPagePresentable>, SearchPageInteractable {

    weak var router: SearchPageRouting?
    weak var listener: SearchPageListener?

    override init(presenter: SearchPagePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
}

// MARK: - PresentableListener

extension SearchPageInteractor: SearchPagePresentableListener {    
    func didSelectPage(type: SearchType) {
        router?.showChild(type: type)
    }
    
    func scrollTo(type: SearchType) -> ViewControllable? {
        return router?.selectChild(type: type)
    }
}

enum SearchType: Int {
    case name
    case condition
}
