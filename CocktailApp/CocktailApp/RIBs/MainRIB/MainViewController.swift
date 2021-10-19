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

final class MainViewController: UITabBarController {

    weak var listener: MainPresentableListener?
    
    private var currentTab = 0
    
    let disposeBag = DisposeBag()
    
    // MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bind()
    }
    
    private func setUI() {
        view.backgroundColor = .white
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            
            self.tabBar.standardAppearance = appearance
            self.tabBar.scrollEdgeAppearance = appearance
        }
    }
    
    private func bind() {
        self.rx.didSelect
            .asDriver()
            .filter { self.currentTab != $0.tabBarItem.tag }
            .compactMap { TabItemType(rawValue: $0.tabBarItem.tag) }
            .drive(with: self, onNext: { owner, type in
                owner.currentTab = type.rawValue
                owner.listener?.didSelectTab(type: type)
            })
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
        case .favorite:
            item.title = "즐겨찾기"
            item.image = UIImage(systemName: "star.fill")
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

extension MainViewController: MainPresentable {
    func showFavoriteChangeAlert(name: String, isFavorite: Bool) {
        let message = isFavorite ? "\(name)이(가) 즐겨찾기에 추가되었습니다." : "\(name)이(가) 즐겨찾기에서 삭제되었습니다."
        
        showToast(message: message)
    }
}

enum TabItemType: Int {
    case list
    case search
    case favorite
}
