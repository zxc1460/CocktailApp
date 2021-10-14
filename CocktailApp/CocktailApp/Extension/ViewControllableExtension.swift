//
//  ViewControllable.swift
//  CocktailApp
//
//

import UIKit
import RIBs

extension ViewControllable {
    func presentViewController(viewControllable: ViewControllable,
                               modalPresentationStyle: UIModalPresentationStyle = .automatic) {
        viewControllable.uiviewController.modalPresentationStyle = modalPresentationStyle
        
        uiviewController.present(viewControllable.uiviewController, animated: true)
    }
    
    func dismissViewController(viewControllable: ViewControllable) {
        viewControllable.uiviewController.dismiss(animated: true)
    }
    
    func presentNavigationViewController(root: ViewControllable) {
        let navigationController = UINavigationController(rootViewController: root.uiviewController)
        uiviewController.present(navigationController, animated: true)
    }
    
    func pushViewController(viewControllable: ViewControllable) {
        uiviewController.navigationController?.pushViewController(viewControllable.uiviewController, animated: true)
    }
    
    func popViewController(viewControllable: ViewControllable) {
        if let topViewController = uiviewController.navigationController?.topViewController,
           topViewController === viewControllable.uiviewController {
            uiviewController.navigationController?.popViewController(animated: true)
        }
    }
}
