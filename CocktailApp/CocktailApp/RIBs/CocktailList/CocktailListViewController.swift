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

protocol CocktailListPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    var typeInput: PublishRelay<ListType> { get }
    var cocktails: BehaviorRelay<[Cocktail]> { get }
    
}

final class CocktailListViewController: UIViewController, CocktailListPresentable, CocktailListViewControllable {

    weak var listener: CocktailListPresentableListener?
    
    var disposeBag = DisposeBag()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl()
        control.insertSegment(withTitle: "인기순", at: 0, animated: true)
        control.insertSegment(withTitle: "최근순", at: 1, animated: true)
        control.selectedSegmentIndex = 0
        return control
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CocktailTableViewCell.self, forCellReuseIdentifier: CocktailTableViewCell.reuseIdentifier)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        bind()
    }
    
    private func setUpViews() {
        self.navigationItem.title = "칵테일 리스트"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(30)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func bind() {
        guard let listener = listener else {
            return
        }
        
        segmentedControl.rx.selectedSegmentIndex
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { index -> ListType in
                return index == 0 ? .popular : .latest
            }
            .bind(to: listener.typeInput)
            .disposed(by: disposeBag)
        
        listener.cocktails
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: CocktailTableViewCell.reuseIdentifier,
                                      cellType: CocktailTableViewCell.self)) {
                (index, cocktail, cell) in
                cell.configure(cocktail)
            }
            .disposed(by: disposeBag)
        
        listener.cocktails
            .map { $0.count > 0 }
            .subscribe(onNext: { [weak self] flag in
                if flag {
                    self?.tableView.scrollToRow(at: IndexPath.zero, at: .top, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
}
