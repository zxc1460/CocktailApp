//
//  FavoriteViewController.swift
//  CocktailApp
//
//

import UIKit
import RIBs
import RxCocoa
import RxSwift
import SnapKit
import Then

protocol FavoritePresentableListener: AnyObject {
    var favoriteListRelay: BehaviorRelay<[CocktailData]> { get }
    
    func deleteFavorite(cocktail: CocktailData)
    func didSelectCocktail(of index: Int)
}

final class FavoriteViewController: UIViewController, FavoritePresentable, FavoriteViewControllable {

    // MARK: - Properties
    
    weak var listener: FavoritePresentableListener?
    
    let disposeBag = DisposeBag()
    
    // MARK: - View Properties
    
    private let tableView = UITableView().then {
        $0.register(FavoriteTableViewCell.self, forCellReuseIdentifier: FavoriteTableViewCell.reuseIdentifier)
        $0.tableFooterView = UIView(frame: .zero)
        $0.separatorStyle = .none
    }
    
    private let emptyLabel = UILabel().then {
        $0.text = "즐겨찾기 내역이 없습니다."
        $0.font = .systemFont(ofSize: 20, weight: .medium)
        $0.textColor = .systemGray
    }
    
    // MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bindUI()
    }
    
    // MARK: - Private
    
    private func setUI() {
        view.backgroundColor = .white
        self.navigationItem.title = "즐겨찾기"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
        
        setConstraints()
    }
    
    private func setConstraints() {
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func bindUI() {
        listener?.favoriteListRelay
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: FavoriteTableViewCell.reuseIdentifier,
                                      cellType: FavoriteTableViewCell.self)) { [weak self] row, cocktail, cell in
                cell.configure(cocktail) {
                    self?.showDeleteFavoriteAlert(cocktail: cocktail)
                }
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, indexPath in
                owner.tableView.deselectRow(at: indexPath, animated: true)
                
                owner.listener?.didSelectCocktail(of: indexPath.row)
            })
            .disposed(by: disposeBag)
        
        listener?.favoriteListRelay
            .asDriver(onErrorJustReturn: [])
            .map { $0.count > 0 }
            .drive(emptyLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func showDeleteFavoriteAlert(cocktail: CocktailData) {
        showAlert(title: nil, message: "\(cocktail.name)을 즐겨찾기에서 삭제하시겠습니까?") { [weak self] in
            self?.listener?.deleteFavorite(cocktail: cocktail)
        }
    }
}
