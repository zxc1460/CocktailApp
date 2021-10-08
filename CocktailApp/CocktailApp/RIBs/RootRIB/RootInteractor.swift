//
//  RootInteractor.swift
//  CocktailApp
//
//

import RIBs
import RxSwift

protocol RootRouting: ViewableRouting {
}

protocol RootPresentable: Presentable {
    var listener: RootPresentableListener? { get set }
}

protocol RootListener: AnyObject {
}

final class RootInteractor: PresentableInteractor<RootPresentable>, RootInteractable {

    weak var router: RootRouting?
    weak var listener: RootListener?

    override init(presenter: RootPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
}

extension RootInteractor: RootPresentableListener {
}
