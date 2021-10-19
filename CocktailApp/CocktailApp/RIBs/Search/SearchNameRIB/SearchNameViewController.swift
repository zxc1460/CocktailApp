//
//  SearchNameViewController.swift
//  CocktailApp
//
//

import UIKit
import RIBs
import RxCocoa
import RxSwift
import SnapKit
import Then

protocol SearchNamePresentableListener: AnyObject {
    var searchResultRelay: BehaviorRelay<[CocktailData]> { get }
    
    func searchCocktailList(name: String)
    func didSelectCocktail(of index: Int)
    func favoriteValueChanged(of cocktail: CocktailData, value: Bool)
}

final class SearchNameViewController: BaseViewController, SearchNamePresentable, SearchNameViewControllable {

    weak var listener: SearchNamePresentableListener?
    
    // MARK: - Views
    
    private let searchBar = UISearchBar().then {
        $0.placeholder = "이름을 입력하세요"
    }
    
    private let tableView = UITableView().then {
        $0.register(CocktailTableViewCell.self, forCellReuseIdentifier: CocktailTableViewCell.reuseIdentifier)
        $0.tableFooterView = UIView(frame: .zero)
        $0.separatorStyle = .none
    }
    
    private let emptyLabel = UILabel().then {
        $0.text = "검색 결과가 없습니다."
        $0.font = .systemFont(ofSize: 20, weight: .medium)
        $0.textColor = .systemGray
    }
    
    // MARK: - Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - UI Methods
    
    override func setUI() {
        view.backgroundColor = .white
        
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
    }
    
    override func setConstraints() {
        searchBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    // MARK: - Rx Method
    
    override func bind() {
        searchBar.rx.searchButtonClicked
            .withLatestFrom(searchBar.rx.text.orEmpty)
            .asDriver(onErrorJustReturn: String())
            .filter { !$0.isEmpty }
            .drive(with: self, onNext: { owner, text in
                owner.searchBar.resignFirstResponder()
                owner.listener?.searchCocktailList(name: text)
            })
            .disposed(by: disposeBag)
                
        listener?.searchResultRelay
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: CocktailTableViewCell.reuseIdentifier,
                                      cellType: CocktailTableViewCell.self)) { [weak self] _, cocktail, cell in
                cell.configure(cocktail) {
                    self?.listener?.favoriteValueChanged(of: cocktail, value: !cocktail.isFavorite)
                }
                
//                cell.favoriteValueChanged
//                    .skip(1)
//                    .subscribe(with: self, onNext: { owner, value in
//                        owner.listener?.favoriteValueChanged(of: cocktail, value: value)
//                    })
//                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        listener?.searchResultRelay
            .asDriver()
            .map { $0.count > 0 }
            .drive(emptyLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .bind(with: self, onNext: { owner, indexPath in
                owner.tableView.deselectRow(at: indexPath, animated: true)
                
                owner.listener?.didSelectCocktail(of: indexPath.row)
            })
            .disposed(by: disposeBag)
    }
}
