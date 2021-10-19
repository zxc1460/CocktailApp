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

final class RootViewController: BaseViewController, RootViewControllable, RootPresentable {

    weak var listener: RootPresentableListener?

    // MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setUI() {
        view.backgroundColor = .white
    }
}
