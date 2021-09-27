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
    var typeInput: PublishRelay<ListType> { get }
    var cocktails: BehaviorRelay<[Cocktail]> { get }
    
    func selectCocktail(index: Int)
}

final class CocktailListViewController: UIViewController, CocktailListPresentable, CocktailListViewControllable {

    weak var listener: CocktailListPresentableListener?
    
    let disposeBag = DisposeBag()
    
    // MARK: - View Properties
    
    private lazy var segmentedControl = UISegmentedControl().then {
        $0.insertSegment(withTitle: "인기순", at: 0, animated: true)
        $0.insertSegment(withTitle: "최근순", at: 1, animated: true)
        $0.selectedSegmentIndex = 0
    }
    
    private lazy var tableView = UITableView().then {
        $0.register(CocktailTableViewCell.self, forCellReuseIdentifier: CocktailTableViewCell.reuseIdentifier)
        $0.tableFooterView = UIView(frame: .zero)
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
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
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
                                      cellType: CocktailTableViewCell.self)) { _, cocktail, cell in
                cell.configure(cocktail)
            }
            .disposed(by: disposeBag)
        
        // 칵테일 리스트 리로드 시 최상단으로 이동
        listener.cocktails
            .delay(.milliseconds(50), scheduler: MainScheduler.instance)
            .map { $0.count > 0 }
            .subscribe(onNext: { [weak self] flag in
                if flag {
                    self?.tableView.scrollToRow(at: IndexPath.zero, at: .top, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        // 칵테일 클릭 시 디테일 뷰로 이동
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
                
                self?.listener?.selectCocktail(index: indexPath.row)
            })
            .disposed(by: disposeBag)
    }
}
