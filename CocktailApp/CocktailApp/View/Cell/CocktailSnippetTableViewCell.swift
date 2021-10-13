//
//  CocktailSnippetTableViewCell.swift
//  CocktailApp
//
//

import UIKit
import SnapKit
import Then

class CocktailSnippetTableViewCell: UITableViewCell {
    static let reuseIdentifier = "CocktailSnippetTableViewCell"
    
    // MARK: - View Properites
    
    private lazy var baseView = UIView().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 15
        $0.layer.borderColor = UIColor.darkGray.cgColor
        $0.layer.borderWidth = 0.1
        
    }
    
    private let thumbnailImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.borderWidth = 0.1
        $0.layer.borderColor = UIColor.darkGray.cgColor
        $0.layer.cornerRadius = 50
    }
    
    private let nameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 30, weight: .bold)
        $0.adjustsFontSizeToFitWidth = true
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
        contentView.addSubview(baseView)
        
        baseView.addSubview(thumbnailImageView)
        baseView.addSubview(nameLabel)
        
        setConstraints()
    }
    
    private func setConstraints() {
        baseView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        thumbnailImageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview().inset(10)
            $0.width.height.equalTo(100)
        }
        
        nameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(10)
        }
    }
    
    func configure(_ cocktail: CocktailSnippet) {
        thumbnailImageView.setCocktailImage(cocktail.thumbnail)
        nameLabel.text = cocktail.name
    }
}
