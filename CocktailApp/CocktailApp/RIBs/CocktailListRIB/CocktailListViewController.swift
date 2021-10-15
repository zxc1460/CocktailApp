//
//  CocktailListViewController.swift
//  CocktailApp
//
//

import UIKit
import RIBs
import RxSwift
import RxCocoa
import SnapKit
import Then

protocol CocktailListPresentableListener: AnyObject {
    var cocktailListRelay: BehaviorRelay<[CocktailData]> { get }
    
    func didSelectCocktail(of index: Int)
    func requestCocktailList(type: ListType)
    func favoriteValueChanged(of cocktail: CocktailData, value: Bool)
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
        $0.separatorStyle = .none
        $0.refreshControl = refreshControl
    }
    
    // MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bindUI()
    }
    
    // MARK: - UI Methods
    
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
        segmentedControl.selectedButtonIndex
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { index -> ListType in
                return ListType.allCases[index]
            }
            .withUnretained(self)
            .subscribe(onNext: { owner, type in
                owner.listener?.requestCocktailList(type: type)
            })
            .disposed(by: disposeBag)
        
        listener?.cocktailListRelay
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: CocktailTableViewCell.reuseIdentifier,
                                      cellType: CocktailTableViewCell.self)) { row, cocktail, cell in
                cell.configure(cocktail)
                
                cell.favoriteValueChanged
                    .subscribe(with: self, onNext: { owner, value in
                        owner.listener?.favoriteValueChanged(of: cocktail, value: value)
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        // 칵테일 리스트 리로드 시 최상단으로 이동
        listener?.cocktailListRelay
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
                let type = ListType.allCases[owner.segmentedControl.selectedButtonIndex.value]
                owner.listener?.requestCocktailList(type: type)
                
                owner.refreshControl.endRefreshing()
            })
            .disposed(by: disposeBag)
    }
}
