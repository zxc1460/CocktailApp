//
//  CocktailRandomViewController.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/28.
//

import UIKit
import RIBs
import RxCocoa
import RxSwift
import SnapKit
import Then

protocol CocktailRandomPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    var randomListRelay: BehaviorRelay<[Cocktail]> { get }
    
    func requestRandomList()
    func didSelectCocktail(of index: Int)
}

final class CocktailRandomViewController: UIViewController, CocktailRandomPresentable, CocktailRandomViewControllable {

    // MARK: - Properties
    
    weak var listener: CocktailRandomPresentableListener?
    
    let disposeBag = DisposeBag()
    
    // MARK: - View Properties
    
    private let refreshControl = UIRefreshControl()
    
    private lazy var tableView = UITableView().then {
        $0.register(RandomCocktailTableViewCell.self, forCellReuseIdentifier: RandomCocktailTableViewCell.reuseIdentifier)
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
    
    
    private func setUI() {
        view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "랜덤 리스트"
        
        view.addSubview(tableView)
        
        setConstraints()
    }
    
    private func bindUI() {
        listener?.randomListRelay
            .asDriver()
            .drive(tableView.rx.items(cellIdentifier: RandomCocktailTableViewCell.reuseIdentifier,
                                      cellType: RandomCocktailTableViewCell.self)) { _, cocktail, cell in
                cell.configure(cocktail)
            }
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .withUnretained(self)
            .subscribe(onNext: { obj, _ in
                obj.listener?.requestRandomList()
                obj.refreshControl.endRefreshing()
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .withUnretained(self)
            .debug()
            .subscribe(onNext: { obj, indexPath in
                obj.tableView.deselectRow(at: indexPath, animated: true)
                obj.listener?.didSelectCocktail(of: indexPath.row)
            })
            .disposed(by: disposeBag)
    }
    
    private func setConstraints() {
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
