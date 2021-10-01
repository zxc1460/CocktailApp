//
//  SearchPageRouter.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/30.
//

import RIBs

protocol SearchPageInteractable: Interactable, SearchNameListener, SearchConditionListener{
    var router: SearchPageRouting? { get set }
    var listener: SearchPageListener? { get set }
}

protocol SearchPageViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func addViewController(viewControllable: ViewControllable)
    func setViewController(viewControllable: ViewControllable)
}

final class SearchPageRouter: ViewableRouter<SearchPageInteractable, SearchPageViewControllable> {
    private let searchNameBuilder: SearchNameBuildable
    private var searchNameRouting: SearchNameRouting?
    
    private let searchConditionBuilder: SearchConditionBuildable
    private var searchConditionRouting: SearchConditionRouting?

    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: SearchPageInteractable,
         viewController: SearchPageViewControllable,
         searchNameBuilder: SearchNameBuildable,
         searchConditionBuilder: SearchConditionBuildable) {
        self.searchNameBuilder = searchNameBuilder
        self.searchConditionBuilder = searchConditionBuilder
        
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    override func didLoad() {
        super.didLoad()
        
        buildChildRIBs()
    }
    
    private func buildChildRIBs() {
        let searchNameRouting = searchNameBuilder.build(withListener: interactor)
        self.searchNameRouting = searchNameRouting
        viewController.addViewController(viewControllable: searchNameRouting.viewControllable)
        
        let searchConditionRouting = searchConditionBuilder.build(withListener: interactor)
        self.searchConditionRouting = searchConditionRouting
        viewController.addViewController(viewControllable: searchConditionRouting.viewControllable)
        
        attachChild(searchNameRouting)
        attachChild(searchConditionRouting)
    }
}

extension SearchPageRouter: SearchPageRouting {    
    func showChild(type: SearchType) {
        guard let children = children as? [ViewableRouting] else {
            return
        }
        
        let viewControllable = children[type.rawValue].viewControllable
        
        viewController.setViewController(viewControllable: viewControllable)
    }
    
    func selectChild(type: SearchType) -> ViewControllable? {
        guard let children = children as? [ViewableRouting] else {
            return nil
        }
        
        let viewControllable = children[type.rawValue].viewControllable
        
        return viewControllable
    }
}
