//
//  SearchPageViewController.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/30.
//

import UIKit
import RIBs
import RxCocoa
import RxSwift
import SnapKit
import Then

protocol SearchPagePresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func didSelectPage(type: SearchType)
    func scrollTo(direction: PageDirection) -> ViewControllable?
}

final class SearchPageViewController: UIViewController, SearchPagePresentable {

    weak var listener: SearchPagePresentableListener?
    
    let disposeBag = DisposeBag()
    
    // MARK: - View Properties
    
    private let segmentedControl = UnderlineSegmentedControl(buttonTitles: ["이름으로 검색", "조건으로 검색"])
    
    private let containerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    // MARK: - Page View Controller Property
    private lazy var pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                               navigationOrientation: .horizontal,
                                                               options: nil)
    
    private var dataViewControllers = [UIViewController]()
    private var pageIndexRelay = PublishRelay<Int>()
    private var currentPageIndex = -1
    private var lastContentOffsetX: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bindUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func setUI() {
        view.backgroundColor = .white
        
        view.addSubview(segmentedControl)
        view.addSubview(containerView)
        containerView.addSubview(pageViewController.view)
        
        setConstraints()
        setPageViewController()
    }
    
    private func bindUI() {
        pageIndexRelay
            .withUnretained(self)
            .subscribe(onNext: { owner, index in
                owner.segmentedControl.setIndex(index: index)
            })
            .disposed(by: disposeBag)

        segmentedControl.selectedButtonIndex
            .withUnretained(self)
            .filter { owner, index in
                owner.currentPageIndex != index
            }
            .subscribe(onNext: { owner, index in
                owner.currentPageIndex = index
                
                if let type = SearchType(rawValue: index) {
                    owner.listener?.didSelectPage(type: type)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setConstraints() {
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(2)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        pageViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setPageViewController() {
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
    }
    
    
}

extension SearchPageViewController: SearchPageViewControllable {
    func addViewController(viewControllable: ViewControllable) {
        dataViewControllers.append(viewControllable.uiviewController)
    }
    
    func setViewController(viewControllable: ViewControllable) {
        let direction: UIPageViewController.NavigationDirection =
            viewControllable as? SearchNameViewControllable == nil ? .forward : .reverse
        
        pageViewController.setViewControllers([viewControllable.uiviewController],
                                              direction: direction, animated: true)
    }
}

extension SearchPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let viewController = pendingViewControllers.first, let index = dataViewControllers.firstIndex(of: viewController) {
            if let type = SearchType(rawValue: index) {
                self.listener?.didSelectPage(type: type)
            }
            
            pageIndexRelay.accept(index)
            
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard viewController as? SearchNameViewController == nil else {
            return nil
        }
        
        return listener?.scrollTo(direction: .left)?.uiviewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard viewController as? SearchConditionViewController == nil else {
            return nil
        }
        
        return listener?.scrollTo(direction: .right)?.uiviewController
    }
}


enum PageDirection: Int {
    case left
    case right
}
