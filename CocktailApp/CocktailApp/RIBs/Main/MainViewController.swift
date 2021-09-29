//
//  MainViewController.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/29.
//
import UIKit
import RIBs
import RxCocoa
import RxSwift

protocol MainPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func selectTab(type: TabItemType)
}

final class MainViewController: UITabBarController, MainPresentable {

    weak var listener: MainPresentableListener?
    
    var currentTag = 0
    
    let disposeBag = DisposeBag()
    
    // MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bindUI()
    }
    
    private func setUI() {
        view.backgroundColor = .white
    }
    
    private func bindUI() {
        self.rx.didSelect
            .asDriver()
            .filter { self.currentTag != $0.tabBarItem.tag }
            .compactMap { TabItemType(rawValue: $0.tabBarItem.tag) }
            .drive { [weak self] type in
                self?.currentTag = type.rawValue
                self?.listener?.selectTab(type: type)
            }
            .disposed(by: disposeBag)
    }
}

extension MainViewController: MainViewControllable {
    func addViewController(_ viewControllable: ViewControllable, type: TabItemType) {
        let item = UITabBarItem()
        
        switch type {
        case .list:
            item.title = "리스트"
            item.image = UIImage(systemName: "list.bullet.rectangle")
        case .random:
            item.title = "랜덤"
            item.image = UIImage(systemName: "questionmark.circle")
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
    case random
}
