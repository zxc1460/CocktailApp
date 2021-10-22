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

final class CocktailListViewController: BaseViewController, CocktailListPresentable, CocktailListViewControllable {

    weak var listener: CocktailListPresentableListener?
    
    // MARK: - View Properties
    
    private let segmentedControl = UnderlineSegmentedControl(buttonTitles: ["인기순", "최근순", "랜덤"])
    
    private let tableView = UITableView().then {
        $0.register(CocktailTableViewCell.self, forCellReuseIdentifier: CocktailTableViewCell.reuseIdentifier)
        $0.tableFooterView = UIView(frame: .zero)
        $0.separatorStyle = .none
    }
    
    // MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - UI Methods
    
    override func setUI() {
        self.navigationItem.title = "칵테일 리스트"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(segmentedControl)
        view.addSubview(tableView)
        
        setConstraints()
    }
    
    override func setConstraints() {
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
    
    // MARK: - Rx Method
    
    override func bind() {
        listener?.cocktailListRelay
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: CocktailTableViewCell.reuseIdentifier,
                                      cellType: CocktailTableViewCell.self)) { [weak self] row, cocktail, cell in
                cell.configure(cocktail) {
                    self?.listener?.favoriteValueChanged(of: cocktail, value: !cocktail.isFavorite)
                }
            }
            .disposed(by: disposeBag)
        
        // 칵테일 클릭 시 디테일 뷰로 이동
        tableView.rx.itemSelected
            .bind(with: self, onNext: { owner, indexPath in
                owner.tableView.deselectRow(at: indexPath, animated: true)
                
                owner.listener?.didSelectCocktail(of: indexPath.row)
            })
            .disposed(by: disposeBag)
        
        segmentedControl.selectedButtonIndex
            .asDriver()
            .debounce(.milliseconds(300))
            .map { ListType.allCases[$0] }
            .drive(with: self, onNext: { owner, type in
                owner.listener?.requestCocktailList(type: type)
            })
            .disposed(by: disposeBag)
        
        listener?.cocktailListRelay
            .asDriver()
            .debounce(.milliseconds(50))
            .filter { $0.count > 0 }
            .drive(with: self, onNext: { owner, _ in
                owner.tableView.scrollToRow(at: IndexPath.zero, at: .top, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
