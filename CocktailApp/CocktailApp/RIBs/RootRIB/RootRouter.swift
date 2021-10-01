//
//  RootRouter.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/23.
//

import RIBs

protocol RootInteractable: Interactable, MainListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable> {
    private let mainBuilder: MainBuildable
    private var mainRouting: MainRouting?

    // TODO: Constructor inject child builder protocols to allow building children.
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
        let mainRouting = mainBuilder.build(withListener: interactor)
        
        self.mainRouting = mainRouting
        
        attachChild(mainRouting)
        
        viewController.presentViewController(viewController: mainRouting.viewControllable,
                                             modalPresentationStyle: .fullScreen)
    }
   
}

extension RootRouter: RootRouting {
}
