//
//  SearchPageRouter.swift
//  CocktailApp
//
//

import RIBs

protocol SearchPageInteractable: Interactable, SearchNameListener, SearchFilterListener{
    var router: SearchPageRouting? { get set }
    var listener: SearchPageListener? { get set }
}

protocol SearchPageViewControllable: ViewControllable {
    func addViewController(viewControllable: ViewControllable)
    func setViewController(viewControllable: ViewControllable)
}

final class SearchPageRouter: ViewableRouter<SearchPageInteractable, SearchPageViewControllable> {
    private let searchNameBuilder: SearchNameBuildable
    private var searchNameRouting: SearchNameRouting?
    
    private let searchFilterBuilder: SearchFilterBuildable
    private var searchFilterRouting: SearchFilterRouting?

    init(
        interactor: SearchPageInteractable,
        viewController: SearchPageViewControllable,
        searchNameBuilder: SearchNameBuildable,
        searchFilterBuilder: SearchFilterBuilder
    ) {
        self.searchNameBuilder = searchNameBuilder
        self.searchFilterBuilder = searchFilterBuilder
        
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
        
        let searchFilterRouting = searchFilterBuilder.build(withListener: interactor)
        self.searchFilterRouting = searchFilterRouting
        viewController.addViewController(viewControllable: searchFilterRouting.viewControllable)
        
        attachChild(searchNameRouting)
        attachChild(searchFilterRouting)
    }
}

// MARK: - Routing

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
