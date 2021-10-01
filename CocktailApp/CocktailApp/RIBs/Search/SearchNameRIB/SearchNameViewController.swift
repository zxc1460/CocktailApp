//
//  SearchNameViewController.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/30.
//

import RIBs
import RxSwift
import UIKit

protocol SearchNamePresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class SearchNameViewController: UIViewController, SearchNamePresentable, SearchNameViewControllable {

    weak var listener: SearchNamePresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yellow
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}
