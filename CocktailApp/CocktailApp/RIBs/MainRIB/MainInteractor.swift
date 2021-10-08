//
//  MainInteractor.swift
//  CocktailApp
//
//

import RIBs
import RxSwift

protocol MainRouting: ViewableRouting {
    func routeToChild(type: TabItemType)
}

protocol MainPresentable: Presentable {
    var listener: MainPresentableListener? { get set }
}

protocol MainListener: AnyObject {
}

final class MainInteractor: PresentableInteractor<MainPresentable>, MainInteractable {

    weak var router: MainRouting?
    weak var listener: MainListener?

    override init(presenter: MainPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
}

// MARK: - PresentableListener

extension MainInteractor: MainPresentableListener {
    func didSelectTab(type: TabItemType) {
        router?.routeToChild(type: type)
    }
}
