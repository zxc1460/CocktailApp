//
//  MainViewController.swift
//  CocktailApp
//
//

import UIKit
import RIBs
import RxCocoa
import RxSwift

protocol MainPresentableListener: AnyObject {
    func didSelectTab(type: TabItemType)
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
                self?.listener?.didSelectTab(type: type)
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
        case .search:
            item.title = "검색"
            item.image = UIImage(systemName: "magnifyingglass")
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
    case search
}
