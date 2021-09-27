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
import TagListView
import Then

protocol CocktailDetailPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    var cocktailDetail: BehaviorRelay<Cocktail> { get }
    
    func backButtonDidTap()
}

final class CocktailDetailViewController: UIViewController, CocktailDetailPresentable, CocktailDetailViewControllable {

    weak var listener: CocktailDetailPresentableListener?
    
    let disposeBag = DisposeBag()
    
    // MARK: - View Properties
    
    private lazy var scrollView = UIScrollView()
    
    private lazy var thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "이름"
        $0.font = .systemFont(ofSize: 38, weight: .bold)
        $0.adjustsFontSizeToFitWidth = true
    }
    
    private lazy var categoryLabel = UILabel().then {
        $0.text = "카테고리"
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
        $0.backgroundColor = .red
        $0.tableFooterView = UIView(frame: .zero)
    }
    
    
    // MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bindUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if isMovingFromParent {
            listener?.backButtonDidTap()
        }
    }
    
    private func setUI() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(thumbnailImageView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(categoryLabel)
        scrollView.addSubview(alcoholLabel)
        scrollView.addSubview(tagView)
        scrollView.addSubview(ingredientLabel)
        scrollView.addSubview(tableView)
    }
    
    private func setConstraints(_ cocktail: Cocktail) {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        thumbnailImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view)
            $0.height.equalTo(400)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(view).inset(20)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        alcoholLabel.snp.makeConstraints {
            $0.top.equalTo(categoryLabel.snp.bottom).offset(cocktail.isAlcohol ? 5 : 0)
            $0.leading.equalTo(titleLabel)
            $0.height.equalTo(cocktail.isAlcohol ? 30 : 0)
            $0.width.equalTo(85)
        }
        
        tagView.snp.makeConstraints {
            $0.top.equalTo(cocktail.isAlcohol ? alcoholLabel.snp.bottom : categoryLabel.snp.bottom)
                .offset(15)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        ingredientLabel.snp.makeConstraints {
            $0.top.equalTo(tagView.snp.bottom).offset(cocktail.tags.count > 0 ? 20 : 0)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(ingredientLabel.snp.bottom).offset(15)
            $0.leading.trailing.equalTo(titleLabel)
            $0.height.equalTo(800)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func bindUI() {
        guard let listener = listener else {
            return
        }
        
        listener.cocktailDetail
            .subscribe(onNext: { [weak self] cocktail in
                self?.configureUI(cocktail)
            })
            .disposed(by: disposeBag)
        
        listener.cocktailDetail
            .map { $0.ingredients }
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: IngredientTableViewCell.reuseIdentifier,
                                      cellType: IngredientTableViewCell.self)) { _, data, cell in
                cell.configure(ingredient: data.ingredient, measure: data.measure)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureUI(_ cocktail: Cocktail) {
        setConstraints(cocktail)
        
        thumbnailImageView.setCocktailImage(cocktail.thumbnail)
        
        titleLabel.text = cocktail.name
        categoryLabel.text = cocktail.category
        ingredientLabel.text = cocktail.ingredients.count > 0 ? "재료" : "재료 알 수 없음"
        
        tagView.removeAllTags()
        tagView.addTags(cocktail.tags)
    }
}
