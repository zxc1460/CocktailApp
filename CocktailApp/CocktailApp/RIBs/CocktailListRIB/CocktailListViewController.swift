//
//  CocktailListViewController.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/23.
//

import UIKit
import RIBs
import RxSwift
import RxCocoa
import SnapKit
import Then

protocol CocktailListPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    var cocktailListRelay: BehaviorRelay<[Cocktail]> { get }
    
    func didSelectCocktail(of index: Int)
    func requestCocktailList(type: ListType)
}

final class CocktailListViewController: UIViewController, CocktailListPresentable, CocktailListViewControllable {

    weak var listener: CocktailListPresentableListener?
    
    let disposeBag = DisposeBag()
    
    // MARK: - View Properties
    
    private let refreshControl = UIRefreshControl()
    
    private let segmentedControl = UnderlineSegmentedControl(buttonTitles: ["인기순", "최근순", "랜덤"])
    
    private lazy var tableView = UITableView().then {
        $0.register(CocktailTableViewCell.self, forCellReuseIdentifier: CocktailTableViewCell.reuseIdentifier)
        $0.tableFooterView = UIView(frame: .zero)
        $0.refreshControl = refreshControl
    }
    
    // MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bindUI()
    }
    
    private func setUI() {
        self.navigationItem.title = "칵테일 리스트"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(segmentedControl)
        view.addSubview(tableView)
        
        setConstraints()
    }
    
    private func setConstraints() {
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func bindUI() {
        guard let listener = listener else {
            return
        }
        
        segmentedControl.selectedButtonIndex
            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
            .map { index -> ListType in
                return ListType.allCases[index]
            }
            .withUnretained(self)
            .subscribe(onNext: { owner, type in
                owner.listener?.requestCocktailList(type: type)
            })
            .disposed(by: disposeBag)
        
        listener.cocktailListRelay
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: CocktailTableViewCell.reuseIdentifier,
                                      cellType: CocktailTableViewCell.self)) { _, cocktail, cell in
                cell.configure(cocktail)
            }
            .disposed(by: disposeBag)
        
        // 칵테일 리스트 리로드 시 최상단으로 이동
        listener.cocktailListRelay
            .delay(.milliseconds(50), scheduler: MainScheduler.instance)
            .map { $0.count > 0 }
            .withUnretained(self)
            .subscribe(onNext: { owner, flag in
                if flag {
                    owner.tableView.scrollToRow(at: IndexPath.zero, at: .top, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        // 칵테일 클릭 시 디테일 뷰로 이동
        tableView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, indexPath in
                owner.tableView.deselectRow(at: indexPath, animated: true)
                
                owner.listener?.didSelectCocktail(of: indexPath.row)
            })
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                let type = ListType.allCases[owner.segmentedControl.selectedIndex]
                owner.listener?.requestCocktailList(type: type)
                owner.refreshControl.endRefreshing()
            })
            .disposed(by: disposeBag)
    }
}
