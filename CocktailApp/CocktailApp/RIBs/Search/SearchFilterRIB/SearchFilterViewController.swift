//
//  SearchFilterViewController.swift
//  CocktailApp
//
//

import UIKit
import RIBs
import RxCocoa
import RxSwift
import SnapKit
import Then

protocol SearchFilterPresentableListener: AnyObject {
    var filterTypeRelay: PublishRelay<FilterType> { get }
    var isLoadingRelay: BehaviorRelay<Bool> { get }
    var filterKeywordsRelay: BehaviorRelay<[String]> { get }
    var cocktailListRelay: BehaviorRelay<[CocktailSnippet]> { get }
    
    
    func searchCocktail(type: FilterType, keyword: String)
    func didSelectCocktail(of index: Int)
}

final class SearchFilterViewController: UIViewController, SearchFilterPresentable, SearchFilterViewControllable {
    
    weak var listener: SearchFilterPresentableListener?
    
    let filterDatas = FilterType.allCases
    
    let disposeBag = DisposeBag()
    
    // MARK: - UI Properties
    
    private let loadingView = UIActivityIndicatorView().then {
        $0.style = .large
    }
    
    private lazy var filterSegmentedControl = UISegmentedControl().then {
        for (index, filter) in filterDatas.enumerated() {
            let title: String
            switch filter {
            case .ingredient:
                title = "재료"
            case .category:
                title = "카테고리"
            case .glass:
                title = "병"
            }
            $0.insertSegment(withTitle: title, at: index, animated: false)
        }
    }
    
    private let keywordTextField = UITextField().then {
        $0.placeholder = "검색 키워드를 선택하세요."
        $0.borderStyle = .roundedRect
        $0.tintColor = .clear
        $0.textAlignment = .center
    }
    
    private let tableView = UITableView().then {
        $0.register(CocktailSnippetTableViewCell.self, forCellReuseIdentifier: CocktailSnippetTableViewCell.reuseIdentifier)
        $0.tableFooterView = UIView(frame: .zero)
        $0.separatorStyle = .none
    }
    
    private let emptyLabel = UILabel().then {
        $0.text = "검색 결과가 없습니다."
        $0.font = .systemFont(ofSize: 20, weight: .medium)
        $0.textColor = .systemGray
    }
    
    private let pickerView = UIPickerView()
    private let pickerToolBar = UIToolbar()
    private let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
    private let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    private let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bindUI()
    }
    
    private func setUI() {
        view.backgroundColor = .white
        
        view.addSubview(filterSegmentedControl)
        view.addSubview(keywordTextField)
        view.addSubview(tableView)
        view.addSubview(loadingView)
        view.addSubview(emptyLabel)
        
        pickerToolBar.sizeToFit()
        pickerToolBar.items = [cancelButton, spacer, doneButton]
        
        keywordTextField.inputAccessoryView = pickerToolBar
        keywordTextField.inputView = pickerView
    
        setConstraints()
    }
    
    private func setConstraints() {
        filterSegmentedControl.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        keywordTextField.snp.makeConstraints {
            $0.top.equalTo(filterSegmentedControl.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(filterSegmentedControl)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(keywordTextField.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        loadingView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func bindUI() {
        filterSegmentedControl.rx.selectedSegmentIndex
            .filter { $0 >= 0 && $0 < self.filterDatas.count }
            .map { self.filterDatas[$0] }
            .subscribe(with: self, onNext: { owner, data in
                owner.listener?.filterTypeRelay.accept(data)
                owner.keywordTextField.text = ""
                owner.view.endEditing(true)
                owner.pickerView.selectRow(0, inComponent: 0, animated: false)
            })
            .disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.keywordTextField.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        
        listener?.isLoadingRelay
            .bind(to: loadingView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        listener?.isLoadingRelay
            .map { !$0 }
            .bind(to: loadingView.rx.isHidden)
            .disposed(by: disposeBag)
        
        listener?.filterKeywordsRelay
            .bind(to: pickerView.rx.itemTitles) { _, element in
                return element
            }
            .disposed(by: disposeBag)
        
        doneButton.rx.tap
            .withLatestFrom(pickerView.rx.modelSelected(String.self)) { $1 }
            .compactMap { $0.first }
            .subscribe(with: self, onNext: { owner, keyword in
                let index = owner.filterSegmentedControl.selectedSegmentIndex
                let type = FilterType.allCases[index]
                owner.keywordTextField.resignFirstResponder()
                owner.keywordTextField.text = keyword
                owner.listener?.searchCocktail(type: type, keyword: keyword)
            })
            .disposed(by: disposeBag)
        
        listener?.cocktailListRelay
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: CocktailSnippetTableViewCell.reuseIdentifier,
                                      cellType: CocktailSnippetTableViewCell.self)) { _, cocktail, cell in
                cell.configure(cocktail)
            }
            .disposed(by: disposeBag)
        
        listener?.cocktailListRelay
            .asDriver()
            .map { $0.count > 0 }
            .drive(emptyLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, indexPath in
                owner.tableView.deselectRow(at: indexPath, animated: true)
                
                owner.listener?.didSelectCocktail(of: indexPath.row)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Extension

extension SearchFilterViewController: FilterViewControllable {}
