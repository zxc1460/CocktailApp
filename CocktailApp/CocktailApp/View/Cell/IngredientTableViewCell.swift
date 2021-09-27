//
//  IngredientTableViewCell.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/27.
//

import UIKit
import SnapKit
import Then

class IngredientTableViewCell: UITableViewCell {
    static let reuseIdentifier = "IngredientTableViewCell"
    
    // MARK: - View Properties
    private lazy var stackView = UIStackView().then {
        $0.alignment = .leading
        $0.axis = .vertical
        $0.distribution = .fillEqually
    }
    
    private lazy var ingredientLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 23, weight: .bold)
        $0.adjustsFontSizeToFitWidth = true
    }
    
    private lazy var measureLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 23, weight: .bold)
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
        stackView.addArrangedSubview(ingredientLabel)
        stackView.addArrangedSubview(measureLabel)
        
        contentView.addSubview(stackView)
        
        setConstraints()
    }
    
    private func setConstraints() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    
    func configure(ingredient: String, measure: String) {
        ingredientLabel.text = ingredient
        measureLabel.text = measure
    }
}
