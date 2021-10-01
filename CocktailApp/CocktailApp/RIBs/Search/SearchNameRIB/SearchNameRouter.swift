//
//  SearchNameRouter.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/30.
//

import RIBs

protocol SearchNameInteractable: Interactable {
    var router: SearchNameRouting? { get set }
    var listener: SearchNameListener? { get set }
}

protocol SearchNameViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class SearchNameRouter: ViewableRouter<SearchNameInteractable, SearchNameViewControllable>, SearchNameRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: SearchNameInteractable, viewController: SearchNameViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
