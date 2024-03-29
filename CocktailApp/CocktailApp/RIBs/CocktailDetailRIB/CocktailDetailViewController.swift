//
//  CocktailDetailViewController.swift
//  CocktailApp
//
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
    var cocktailRelay: BehaviorRelay<CocktailData?> { get }
    
    func refreshCocktail()
    func didPopViewController()
    func toggleFavorite()
}

final class CocktailDetailViewController: BaseViewController, CocktailDetailPresentable, CocktailDetailViewControllable {

    // MARK: - Properties
    
    weak var listener: CocktailDetailPresentableListener?
    
    // MARK: - Views
    
    private let refreshControl = UIRefreshControl()
    private let contentView = UIView()
    
    private lazy var scrollView = UIScrollView().then {
        $0.refreshControl = refreshControl
    }

    private let thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    private let nameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 38, weight: .bold)
        $0.adjustsFontSizeToFitWidth = true
    }
    
    private let categoryLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 23, weight: .semibold)
        $0.adjustsFontSizeToFitWidth = true
    }
    
    private let isAlcoholLabel = UILabel().then {
        $0.text = "Alcohol"
        $0.font = .systemFont(ofSize: 18, weight: .bold)
        $0.backgroundColor = UIColor.init(hex: "#8AB7F8")
        $0.textColor = .white
        $0.textAlignment = .center
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
    }
    
    private let tagListView = TagListView().then {
        $0.textFont = .systemFont(ofSize: 18, weight: .bold)
        $0.textColor = .white
        $0.alignment = .leading
        $0.paddingX = 10
        $0.paddingY = 5
        $0.marginX = 5
        $0.marginY = 5
        $0.cornerRadius = 10
        $0.tagBackgroundColor = .systemOrange
    }
    
    private let ingredientTitleLabel = UILabel().then {
        $0.text = "재료"
        $0.font = .systemFont(ofSize: 30, weight: .bold)
    }
    
    private let ingredientTableView = UITableView().then {
        $0.register(IngredientTableViewCell.self, forCellReuseIdentifier: IngredientTableViewCell.reuseIdentifier)
        $0.isScrollEnabled = false
        $0.allowsSelection = false
        $0.tableFooterView = UIView(frame: .zero)
    }
    
    private let instructionTitleLabel = UILabel().then {
        $0.text = "제조법"
        $0.font = .systemFont(ofSize: 30, weight: .bold)
    }
    
    private let instructionDetailLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 18)
    }
    
    
    private let favoriteButton = UIButton().then {
        $0.setImage(.favoriteButtonImage, for: .normal)
        $0.setImage(.favoriteButtonSelectedImage, for: .selected)
        $0.tintColor = .systemRed
        $0.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
    }
    
    private lazy var rightBarButton = UIBarButtonItem(customView: favoriteButton)
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if isMovingFromParent {
            listener?.didPopViewController()
        }
    }
    
    // MARK: - UI Methods
    
    override func setUI() {
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.rightBarButtonItem = rightBarButton
        self.tabBarController?.tabBar.isHidden = true
        
        view.backgroundColor = .white

        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(isAlcoholLabel)
        contentView.addSubview(tagListView)
        contentView.addSubview(ingredientTitleLabel)
        contentView.addSubview(ingredientTableView)
        contentView.addSubview(instructionTitleLabel)
        contentView.addSubview(instructionDetailLabel)
    }
    
    override func setConstraints() {
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
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(contentView).inset(20)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(nameLabel)
        }
        
        isAlcoholLabel.snp.makeConstraints {
            $0.top.equalTo(categoryLabel.snp.bottom).offset(5)
            $0.leading.equalTo(nameLabel)
            $0.height.equalTo(30)
            $0.width.equalTo(85)
        }
        
        tagListView.snp.makeConstraints {
            $0.top.equalTo(isAlcoholLabel.snp.bottom).offset(15)
            $0.leading.trailing.equalTo(nameLabel)
        }
        
        ingredientTitleLabel.snp.makeConstraints {
            $0.top.equalTo(tagListView.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(nameLabel)
        }
        
        ingredientTableView.snp.makeConstraints {
            $0.height.equalTo(100)
            $0.top.equalTo(ingredientTitleLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(nameLabel)
        }
        
        instructionTitleLabel.snp.makeConstraints {
            $0.top.equalTo(ingredientTableView.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(nameLabel)
        }
        
        instructionDetailLabel.snp.makeConstraints {
            $0.top.equalTo(instructionTitleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(nameLabel)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    // MARK: - Rx Methods
    
    override func bind() {
        listener?.cocktailRelay
            .compactMap { $0 }
            .map { Array($0.ingredients) }
            .asDriver(onErrorJustReturn: [])
            .drive(ingredientTableView.rx.items(cellIdentifier: IngredientTableViewCell.reuseIdentifier,
                                      cellType: IngredientTableViewCell.self)) { _, data, cell in
                cell.configure(ingredient: data.name, measure: data.measure)
            }
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(with: self, onNext: { owner, _ in
                owner.listener?.refreshCocktail()
                owner.refreshControl.endRefreshing()
            })
            .disposed(by: disposeBag)
        
        favoriteButton.rx.controlEvent(.touchUpInside)
            .bind(with: self, onNext: { owner, _ in
                owner.listener?.toggleFavorite()
            })
            .disposed(by: disposeBag)
        
        ingredientTableView.rx.observe(CGSize.self, #keyPath(UITableView.contentSize))
            .compactMap { $0?.height }
            .asDriver(onErrorJustReturn: CGFloat.zero)
            .drive(with: self, onNext: { owner, height in
                owner.ingredientTableView.contentsHeight = height
            })
            .disposed(by: disposeBag)
        
        listener?.cocktailRelay
            .asDriver()
            .compactMap { $0 }
            .drive(with: self, onNext: { owner, cocktail in
                owner.configureUI(by: cocktail)
            })
            .disposed(by: disposeBag)
        
        listener?.cocktailRelay
            .compactMap { $0 }
            .take(1)
            .bind(with: self, onNext: { owner, cocktail in
                owner.driveFavorite(cocktail: cocktail)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureUI(by cocktail: CocktailData) {
        thumbnailImageView.setCocktailImage(cocktail.thumbnail)
        
        nameLabel.text = cocktail.name
        categoryLabel.text = cocktail.category
        ingredientTitleLabel.text = cocktail.ingredients.count > 0 ? "재료" : "재료 알 수 없음"
        instructionDetailLabel.text = cocktail.instruction
        tagListView.removeAllTags()
        tagListView.addTags(Array(cocktail.tags))
        isAlcoholLabel.isHidden = !cocktail.isAlcohol
    }
    
    private func driveFavorite(cocktail: CocktailData) {
        cocktail.isFavoriteChanged
            .asDriver(onErrorJustReturn: false)
            .drive(favoriteButton.rx.isSelected)
            .disposed(by: disposeBag)
    }
}
