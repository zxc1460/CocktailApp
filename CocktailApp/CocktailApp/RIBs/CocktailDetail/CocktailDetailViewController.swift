//
//  CocktailDetailViewController.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/27.
//

import UIKit
import Kingfisher
import RIBs
import RxCocoa
import RxSwift
import SnapKit
import TagListView
import Then

protocol CocktailDetailPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    var cocktailDetail: BehaviorRelay<Cocktail> { get }
    
    func refreshCocktail()
    func backButtonDidTap()
}

final class CocktailDetailViewController: UIViewController, CocktailDetailPresentable, CocktailDetailViewControllable {

    // MARK: - Properties
    
    weak var listener: CocktailDetailPresentableListener?
    
    let disposeBag = DisposeBag()
    
    // MARK: - View Properties
    
    private lazy var refreshControl = UIRefreshControl()
    private lazy var contentView = UIView()
    
    private lazy var scrollView = UIScrollView().then {
        $0.refreshControl = refreshControl
    }

    private lazy var thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 38, weight: .bold)
        $0.adjustsFontSizeToFitWidth = true
    }
    
    private lazy var categoryLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 23, weight: .semibold)
        $0.adjustsFontSizeToFitWidth = true
    }
    
    private lazy var alcoholLabel = UILabel().then {
        $0.text = "Alcohol"
        $0.font = .systemFont(ofSize: 18, weight: .bold)
        $0.backgroundColor = UIColor.init(hex: "#8AB7F8")
        $0.textColor = .white
        $0.textAlignment = .center
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
    }
    
    private lazy var tagView = TagListView().then {
        $0.textFont = .systemFont(ofSize: 18, weight: .bold)
        $0.textColor = .white
        $0.alignment = .leading
        $0.paddingY = 5
        $0.paddingX = 10
        $0.marginY = 5
        $0.marginX = 5
        $0.cornerRadius = 10
        $0.tagBackgroundColor = .systemOrange
    }
    
    private lazy var ingredientLabel = UILabel().then {
        $0.text = "재료"
        $0.font = .systemFont(ofSize: 30, weight: .bold)
    }
    
    private lazy var tableView = UITableView().then {
        $0.register(IngredientTableViewCell.self, forCellReuseIdentifier: IngredientTableViewCell.reuseIdentifier)
        $0.isScrollEnabled = false
        $0.allowsSelection = false
        $0.tableFooterView = UIView(frame: .zero)
    }
    
    private lazy var instructionTextLabel = UILabel().then {
        $0.text = "제조법"
        $0.font = .systemFont(ofSize: 30, weight: .bold)
    }
    
    private lazy var instructionLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 18)
    }
    
    private var tableViewHeight: Constraint?
    
    // MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bindUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if isMovingFromParent {
            listener?.backButtonDidTap()
        }
    }
    
    // MARK: - Methods
    
    private func setUI() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.tabBarController?.tabBar.isHidden = true

        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(alcoholLabel)
        contentView.addSubview(tagView)
        contentView.addSubview(ingredientLabel)
        contentView.addSubview(tableView)
        contentView.addSubview(instructionTextLabel)
        contentView.addSubview(instructionLabel)
        
        setConstraints()
    }
    
    private func setConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view)
        }
        
        contentView.snp.makeConstraints {
            $0.top.bottom.equalTo(scrollView)
            $0.leading.trailing.equalTo(view)
        }
        
        thumbnailImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(400)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(contentView).inset(20)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        alcoholLabel.snp.makeConstraints {
            $0.top.equalTo(categoryLabel.snp.bottom).offset(5)
            $0.leading.equalTo(titleLabel)
            $0.height.equalTo(30)
            $0.width.equalTo(85)
        }
        
        tagView.snp.makeConstraints {
            $0.top.equalTo(alcoholLabel.snp.bottom)
                .offset(15)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        ingredientLabel.snp.makeConstraints {
            $0.top.equalTo(tagView.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        tableView.snp.makeConstraints {
            $0.height.equalTo(100)
            $0.top.equalTo(ingredientLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        instructionTextLabel.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        instructionLabel.snp.makeConstraints {
            $0.top.equalTo(instructionTextLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(titleLabel)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    private func bindUI() {
        guard let listener = listener else {
            return
        }
        
        listener.cocktailDetail
            .map { $0.ingredients }
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: IngredientTableViewCell.reuseIdentifier,
                                      cellType: IngredientTableViewCell.self)) { _, data, cell in
                cell.configure(ingredient: data.name, measure: data.measure)
            }
            .disposed(by: disposeBag)
        
        listener.cocktailDetail
            .subscribe(onNext: { [weak self] cocktail in
                self?.configureUI(cocktail)
            })
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                self?.listener?.refreshCocktail()
                self?.refreshControl.endRefreshing()
            })
            .disposed(by: disposeBag)
        
        
        // table view height Observable
        tableView.rx.observe(CGSize.self, #keyPath(UITableView.contentSize))
            .compactMap { $0 }
            .map { $0.height }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] height in
                self?.tableView.height = height
            })
            .disposed(by: disposeBag)
    }
    
    private func configureUI(_ cocktail: Cocktail) {
        thumbnailImageView.setCocktailImage(cocktail.thumbnail)
        
        titleLabel.text = cocktail.name
        categoryLabel.text = cocktail.category
        ingredientLabel.text = cocktail.ingredients.count > 0 ? "재료" : "재료 알 수 없음"
        instructionLabel.text = cocktail.instruction
        tagView.removeAllTags()
        tagView.addTags(cocktail.tags)
    }
}
