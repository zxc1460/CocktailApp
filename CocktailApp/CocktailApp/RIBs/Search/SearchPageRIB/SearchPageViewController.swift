//
//  SearchPageViewController.swift
//  CocktailApp
//
//


import UIKit
import RIBs
import RxCocoa
import RxSwift
import SnapKit
import Then

protocol SearchPagePresentableListener: AnyObject {
    func didSelectPage(type: SearchType)
    func scrollTo(type: SearchType) -> ViewControllable?
}

final class SearchPageViewController: BaseViewController, SearchPagePresentable {

    weak var listener: SearchPagePresentableListener?
        
    // MARK: - Views
    
    private let segmentedControl = UnderlineSegmentedControl(buttonTitles: ["이름으로 검색", "조건으로 검색"])
    
    private let containerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    // MARK: - Page View Controller Property
    private lazy var pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                               navigationOrientation: .horizontal,
                                                               options: nil)
    
    private var dataViewControllers = [UIViewController]()
    private var currentPageIndex = -1
    
    // MARK: - Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Methods related UI
    
    override func setUI() {
        view.backgroundColor = .white
        self.navigationItem.title = "검색"
        
        view.addSubview(segmentedControl)
        view.addSubview(containerView)
        containerView.addSubview(pageViewController.view)
        
        setPageViewController()
    }
    
    override func setConstraints() {
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
    
    override func bind() {
        pageViewController.rx.willTransitionToViewControllers
            .compactMap { $0.first }
            .compactMap { self.dataViewControllers.firstIndex(of: $0) }
            .bind(to: segmentedControl.selectedButtonIndex)
            .disposed(by: disposeBag)
    }
    
    override func subscribe() {
        segmentedControl.selectedButtonIndex
            .withUnretained(self)
            .filter { owner, index in
                owner.currentPageIndex != index
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { owner, index in
                owner.currentPageIndex = index
                
                if let type = SearchType(rawValue: index) {
                    owner.listener?.didSelectPage(type: type)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setPageViewController() {
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
        pageViewController.dataSource = self
    }
}

// MARK: - ViewControllable

extension SearchPageViewController: SearchPageViewControllable {
    func addViewController(viewControllable: ViewControllable) {
        dataViewControllers.append(viewControllable.uiviewController)
    }
    
    func setViewController(viewControllable: ViewControllable) {
        let direction: UIPageViewController.NavigationDirection = viewControllable as? SearchNameViewControllable == nil
            ? .forward
            : .reverse
        
        pageViewController.setViewControllers(
            [viewControllable.uiviewController],
            direction: direction,
            animated: true
        )
    }
}

// MARK: - UIPageViewControllerDelegate

extension SearchPageViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let index = dataViewControllers.firstIndex(of: viewController),
              let type = SearchType(rawValue: index - 1)
        else {
            return nil
        }

        return listener?.scrollTo(type: type)?.uiviewController
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController)
    -> UIViewController? {
        guard let index = dataViewControllers.firstIndex(of: viewController),
              let type = SearchType(rawValue: index + 1)
        else {
            return nil
        }

        return listener?.scrollTo(type: type)?.uiviewController
    }
}
