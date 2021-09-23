//
//  CocktailListViewController.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/23.
//

import RIBs
import RxSwift
import UIKit

protocol CocktailListPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class CocktailListViewController: UIViewController, CocktailListPresentable, CocktailListViewControllable {

    weak var listener: CocktailListPresentableListener?
    
//    private lazy var tableView: UITableView = {
//       let tableView = UITableView()
//        return tableView
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "칵테일 리스트"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
}
