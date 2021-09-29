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
        
        self.view.backgroundColor = .white
    }
    
}

extension RootViewController: RootViewControllable {
}
