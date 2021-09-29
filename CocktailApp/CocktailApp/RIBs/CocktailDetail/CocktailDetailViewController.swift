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
    var cocktailRelay: BehaviorRelay<Cocktail> { get }
    
    func refreshCocktail()
    func didPopViewController()
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
    
    private lazy var nameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 38, weight: .bold)
        $0.adjustsFontSizeToFitWidth = true
    }
    
    private lazy var categoryLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 23, weight: .semibold)
        $0.adjustsFontSizeToFitWidth = true
    }
    
    private lazy var isAlcoholLabel = UILabel().then {
        $0.text = "Alcohol"
        $0.font = .systemFont(ofSize: 18, weight: .bold)
        $0.backgroundColor = UIColor.init(hex: "#8AB7F8")
        $0.textColor = .white
        $0.textAlignment = .center
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
    }
    
    private lazy var tagListView = TagListView().then {
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
    
    private lazy var ingredientTitleLabel = UILabel().then {
        $0.text = "재료"
        $0.font = .systemFont(ofSize: 30, weight: .bold)
    }
    
    private lazy var ingredientTableView = UITableView().then {
        $0.register(IngredientTableViewCell.self, forCellReuseIdentifier: IngredientTableViewCell.reuseIdentifier)
        $0.isScrollEnabled = false
        $0.allowsSelection = false
        $0.tableFooterView = UIView(frame: .zero)
    }
    
    private lazy var instructionTitleLabel = UILabel().then {
        $0.text = "제조법"
        $0.font = .systemFont(ofSize: 30, weight: .bold)
    }
    
    private lazy var instructionDetailLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 18)
    }
    
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
            listener?.didPopViewController()
        }
    }
    
    // MARK: - Methods
    
    private func setUI() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
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
            $0.top.equalTo(isAlcoholLabel.snp.bottom)
                .offset(15)
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
    
    private func bindUI() {
        guard let listener = listener else {
            return
        }
        
        listener.cocktailRelay
            .map { $0.ingredients }
            .asDriver(onErrorJustReturn: [])
            .drive(ingredientTableView.rx.items(cellIdentifier: IngredientTableViewCell.reuseIdentifier,
                                      cellType: IngredientTableViewCell.self)) { _, data, cell in
                cell.configure(ingredient: data.name, measure: data.measure)
            }
            .disposed(by: disposeBag)
        
        listener.cocktailRelay
            .withUnretained(self)
            .subscribe(onNext: { obj, cocktail in
                obj.drawUI(by: cocktail)
            })
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .withUnretained(self)
            .subscribe(onNext: { obj, _ in
                obj.listener?.refreshCocktail()
                obj.refreshControl.endRefreshing()
            })
            .disposed(by: disposeBag)
        
        
        // table view height Observable
        ingredientTableView.rx.observe(CGSize.self, #keyPath(UITableView.contentSize))
            .compactMap { $0?.height }
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { obj, height in
                obj.ingredientTableView.height = height
            })
            .disposed(by: disposeBag)
    }
    
    private func drawUI(by cocktail: Cocktail) {
        thumbnailImageView.setCocktailImage(cocktail.thumbnail)
        
        nameLabel.text = cocktail.name
        categoryLabel.text = cocktail.category
        ingredientTitleLabel.text = cocktail.ingredients.count > 0 ? "재료" : "재료 알 수 없음"
        instructionDetailLabel.text = cocktail.instruction
        tagListView.removeAllTags()
        tagListView.addTags(cocktail.tags)
    }
}
