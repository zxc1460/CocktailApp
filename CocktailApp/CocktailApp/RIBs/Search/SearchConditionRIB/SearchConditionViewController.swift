//
//  SearchConditionViewController.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/30.
//

import UIKit
import RIBs
import RxSwift
import SnapKit

protocol SearchConditionPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class SearchConditionViewController: UIViewController, SearchConditionPresentable, SearchConditionViewControllable {

    weak var listener: SearchConditionPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}
