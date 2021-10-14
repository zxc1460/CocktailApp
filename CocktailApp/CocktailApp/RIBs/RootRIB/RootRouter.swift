//
//  RootRouter.swift
//  CocktailApp
//
//

import RIBs

protocol RootInteractable: Interactable, MainListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable> {
    private let mainBuilder: MainBuildable
    private var mainRouting: MainRouting?

    init(interactor: RootInteractable,
        viewController: RootViewControllable,
        mainBuilder: MainBuildable) {
        self.mainBuilder = mainBuilder
        
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    override func didLoad() {
        super.didLoad()
        
        routeToMain()
    }
    
    func routeToMain() {
        let mainRouting = mainBuilder.build(withListener: interactor, repository: CommonRepository())
        
        self.mainRouting = mainRouting
        
        attachChild(mainRouting)
        
        viewController.presentViewController(viewControllable: mainRouting.viewControllable,
                                             modalPresentationStyle: .fullScreen)
    }
   
}

extension RootRouter: RootRouting {
}
