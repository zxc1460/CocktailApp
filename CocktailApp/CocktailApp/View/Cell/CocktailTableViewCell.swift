//
    //  CocktailTableViewCell.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/24.
//

import UIKit
import Kingfisher
import RxCocoa
import RxSwift
import SnapKit
import Then



class CocktailTableViewCell: UITableViewCell {
    static let reuseIdentifier = "CocktailTableViewCell"
    
    // MARK: - View Properties
    
    private lazy var thumbnailView = UIImageView().then {
        $0.layer.cornerRadius = 50
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    
    private lazy var nameLabel = UILabel().then {
        $0.text = "Name"
        $0.font = .systemFont(ofSize: 25, weight: .bold)
        $0.adjustsFontSizeToFitWidth = true
    }
    
    private lazy var categoryLabel = UILabel().then {
        $0.text = "Category"
        $0.font = .systemFont(ofSize: 18, weight: .medium)
        $0.adjustsFontSizeToFitWidth = true
    }
    
    private lazy var isAlcoholLabel = UILabel().then {
        $0.text = "Alcohol"
        $0.font = .systemFont(ofSize: 15, weight: .bold)
        $0.backgroundColor = UIColor.init(hex: "#8AB7F8")
        $0.textColor = .white
        $0.textAlignment = .center
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
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
    
    
    private func setUI() {
        contentView.addSubview(thumbnailView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(isAlcoholLabel)
        
        setConstraints()
    }
    
    private func setConstraints() {
        thumbnailView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview().inset(20)
            $0.width.height.equalTo(100)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(thumbnailView.snp.trailing).offset(10)
            $0.top.trailing.equalToSuperview().inset(20)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(nameLabel)
            $0.centerY.equalToSuperview()
        }
        
        isAlcoholLabel.snp.makeConstraints {
            $0.bottom.equalTo(thumbnailView)
            $0.leading.equalTo(nameLabel)
            $0.width.equalTo(70)
            $0.height.equalTo(22)
        }
    }
    
    func configure(_ cocktail: Cocktail) {
        thumbnailView.setCocktailImage(cocktail.thumbnail)
        nameLabel.text = cocktail.name
        categoryLabel.text = cocktail.category
        isAlcoholLabel.isHidden = !cocktail.isAlcohol
    }
}
