//
//  RandomCocktailTableViewCell.swift
//  CocktailApp
//
//  

import UIKit
import RxCocoa
import RxRealm
import RxSwift
import SnapKit
import Then

class CocktailTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "CocktailTableViewCell"
    
    var disposeBag = DisposeBag()
    var favoriteValueChanged = BehaviorRelay<Bool>(value: false)
    
    // MARK: - View Properites
    
    private lazy var baseView = UIView().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 15
        $0.layer.borderColor = UIColor.darkGray.cgColor
        $0.layer.borderWidth = 0.1
        
    }
    
    private let thumbnailImageView = UIImageView()
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 10
        $0.distribution = .fill
    }
    
    private let nameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 25, weight: .bold)
        $0.adjustsFontSizeToFitWidth = true
    }
    
    private let categoryLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 22, weight: .medium)
        $0.adjustsFontSizeToFitWidth = true
    }
    
    private let glassLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 22, weight: .medium)
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
    
    private let favoriteButton = UIButton().then {
        $0.setImage(UIImage(systemName: "heart"), for: .normal)
        $0.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        $0.tintColor = .systemRed
    }
    
    // MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Override Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    private func setUI() {
        contentView.addSubview(baseView)
        
        baseView.addSubview(thumbnailImageView)
        baseView.addSubview(stackView)
        baseView.addSubview(favoriteButton)
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(categoryLabel)
        stackView.addArrangedSubview(glassLabel)
        stackView.addArrangedSubview(isAlcoholLabel)
        
        setConstraints()
    }
    
    private func setConstraints() {
        baseView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        thumbnailImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(300)
        }
        
        favoriteButton.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(10)
            $0.trailing.equalTo(thumbnailImageView).inset(10)
            $0.width.height.equalTo(20)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(favoriteButton.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(10)
        }
        
        isAlcoholLabel.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.width.equalTo(85)
        }
    }
    
    func configure(_ cocktail: CocktailData, favoriteButtonAction: @escaping () -> Void) {
        thumbnailImageView.setCocktailImage(cocktail.thumbnail)
        nameLabel.text = cocktail.name
        categoryLabel.text = cocktail.category
        glassLabel.text = cocktail.glass
        isAlcoholLabel.isHidden = !cocktail.isAlcohol
        
        favoriteButton.rx.controlEvent(.touchUpInside)
            .bind(onNext: {
                favoriteButtonAction()
            })
            .disposed(by: disposeBag)
        
        cocktail.isFavoriteChanged
            .asDriver(onErrorJustReturn: false)
            .drive(favoriteButton.rx.isSelected)
            .disposed(by: disposeBag)
    }
}
