//
//  RootViewController.swift
//  CocktailApp
//
//

import UIKit
import RIBs
import RxCocoa
import RxSwift

protocol RootPresentableListener: AnyObject {
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
