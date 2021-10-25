//
//  FavoriteTableViewCell.swift
//  CocktailApp
//
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

class FavoriteTableViewCell: UITableViewCell {
    static let reuseIdentifier = "FavoriteTableViewCell"
    
    private var disposeBag = DisposeBag()
    
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
    
    private let deleteButton = UIButton().then {
        $0.setTitle("삭제", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        $0.backgroundColor = .systemRed
    }
    
    
    // MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(categoryLabel)
        stackView.addArrangedSubview(glassLabel)
        stackView.addArrangedSubview(deleteButton)
        
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
    
        stackView.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(10)
        }
        
        deleteButton.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.width.equalToSuperview()
        }
    }
    
    func configure(_ cocktail: CocktailData, deleteAction: @escaping () -> Void) {
        nameLabel.text = cocktail.name
        categoryLabel.text = cocktail.category
        glassLabel.text = cocktail.glass
        thumbnailImageView.setCocktailImage(cocktail.thumbnail)
        
        deleteButton.rx.controlEvent(.touchUpInside)
            .bind {
                deleteAction()
            }
            .disposed(by: disposeBag)
    }
}
