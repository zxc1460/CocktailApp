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
    var filterInputRelay: PublishRelay<FilterType> { get }
//    var keywordDataRelay: BehaviorRelay<[String]> { get }
//    var keywordInputRelay: PublishRelay<String> { get }
//    var cocktailListRelay: BehaviorRelay<[Cocktail]> { get }
}

final class SearchFilterViewController: UIViewController, SearchFilterPresentable, SearchFilterViewControllable {
    
    weak var listener: SearchFilterPresentableListener?
    
    let filterDatas = FilterType.allCases
    
    let disposeBag = DisposeBag()
    
    // MARK: - UI Properties
    
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
        
        
        $0.selectedSegmentIndex = 0
    }
    
    private let keywordTextField = UITextField().then {
        $0.placeholder = "검색 키워드를 선택하세요."
        $0.borderStyle = .roundedRect
        $0.tintColor = .clear
        $0.textAlignment = .center
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
    }
    
    private func bindUI() {
        guard let listener = listener else {
            return
        }
        
        filterSegmentedControl.rx.selectedSegmentIndex
            .map { self.filterDatas[$0] }
            .debug()
            .bind(to: listener.filterInputRelay)
            .disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.keywordTextField.resignFirstResponder()
            })
            .disposed(by: disposeBag)
    }
}
