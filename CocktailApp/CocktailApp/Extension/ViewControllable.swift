//
//  ViewControllable.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/27.
//
import UIKit
import RIBs

extension ViewControllable {
    func presentViewController(viewController: ViewControllable) {
        uiviewController.present(viewController.uiviewController, animated: true)
    }
    
    func dismissViewController(viewController: ViewControllable) {
        viewController.uiviewController.dismiss(animated: true)
    }
    
    func presentNavigationViewController(root: ViewControllable) {
        let navigationController = UINavigationController(rootViewController: root.uiviewController)
        uiviewController.present(navigationController, animated: true)
    }
    
    func pushViewController(viewController: ViewControllable) {
        uiviewController.navigationController?.pushViewController(viewController.uiviewController, animated: true)
    }
    
    func popViewController(viewController: ViewControllable) {
        if let topViewController = uiviewController.navigationController?.topViewController,
           topViewController === viewController.uiviewController {
            uiviewController.navigationController?.popViewController(animated: true)
        }
    }
}
