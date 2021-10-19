//
//  BaseViewController.swift
//  CocktailApp
//
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setConstraints()
        bind()
        subscribe()
    }
    
    func setUI() {}
    func setConstraints() {}
    func bind() {}
    func subscribe() {}
}
