//
//  RootViewController.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/23.
//

import UIKit
import RIBs
import RxCocoa
import RxSwift

protocol RootPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class RootViewController: UITabBarController, RootPresentable {

    weak var listener: RootPresentableListener?
    
    // MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
    }
}

extension RootViewController: RootViewControllable {
    func selectTabItem(type: TabItemType) {
        self.selectedIndex = type.rawValue
    }
    
    func addViewController(_ viewControllable: ViewControllable, type: TabItemType) {
        let item = UITabBarItem()
        
        switch type {
        case .list:
            item.title = "리스트"
            item.image = UIImage(systemName: "list.bullet.rectangle")
        }
        
        item.tag = type.rawValue
        
        viewControllable.uiviewController.tabBarItem = item
        
        let navigationController = UINavigationController(rootViewController: viewControllable.uiviewController)
        
        if viewControllers == nil {
            viewControllers = [navigationController]
        } else {
            viewControllers?.append(navigationController)
        }
    }
}



enum TabItemType: Int {
    case list
}
