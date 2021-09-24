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



class CocktailTableViewCell: UITableViewCell {
    static let reuseIdentifier = "CocktailTableViewCell"
    var disposeBag = DisposeBag()
    
    private lazy var thumbnailView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "name"
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var categoryLabel: UILabel = {
       let label = UILabel()
        label.text = "category"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var alcoholLabel: UILabel = {
       let label = UILabel()
        label.text = "Alcohol"
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.backgroundColor = UIColor.init(hex: "#8AB7F8")
        label.textColor = .white
        label.textAlignment = .center
        label.clipsToBounds = true
        label.layer.cornerRadius = 10
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpViews()
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
    
    
    private func setUpViews() {
        contentView.addSubview(thumbnailView)
        thumbnailView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview().inset(20)
            $0.width.height.equalTo(100)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(thumbnailView.snp.trailing).offset(10)
            $0.top.trailing.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(nameLabel)
            $0.centerY.equalToSuperview()
        }
        
        contentView.addSubview(alcoholLabel)
        alcoholLabel.snp.makeConstraints {
            $0.bottom.equalTo(thumbnailView)
            $0.leading.equalTo(nameLabel)
            $0.width.equalTo(70)
            $0.height.equalTo(22)
        }
    }
    
    func configure(_ cocktail: Cocktail) {
        if let url = URL(string: cocktail.thumbnail) {
            thumbnailView.kf.setImage(with: url)
        }
        nameLabel.text = cocktail.name
        categoryLabel.text = cocktail.category
        alcoholLabel.isHidden = !cocktail.isAlcohol
    }
}
