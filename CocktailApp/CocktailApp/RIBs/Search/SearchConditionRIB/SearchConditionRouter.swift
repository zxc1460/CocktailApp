//
//  SearchConditionRouter.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/30.
//

import RIBs

protocol SearchConditionInteractable: Interactable {
    var router: SearchConditionRouting? { get set }
    var listener: SearchConditionListener? { get set }
}

protocol SearchConditionViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class SearchConditionRouter: ViewableRouter<SearchConditionInteractable, SearchConditionViewControllable>, SearchConditionRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: SearchConditionInteractable, viewController: SearchConditionViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
