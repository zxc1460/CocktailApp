//
//  UnderlineSegmentedControl.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/30.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class UnderlineSegmentedControl: UIView {
    private var buttonTitles = [String]()
    private var buttons = [UIButton]()
    private var selectorView: UIView!
    
    var textColor = UIColor.black
    var selectorViewColor = UIColor.systemBlue
    var selectorTextColor = UIColor.systemBlue
    
    public private(set) var selectedIndex = 0
    
    var selectedButtonIndex = PublishRelay<Int>()
    
    convenience init(buttonTitles: [String]) {
        self.init(frame: .zero)
        self.buttonTitles = buttonTitles
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.backgroundColor = .white
        updateView()
    }
    
    func setButtonTitles(_ buttonTitles: [String]) {
        self.buttonTitles = buttonTitles
        updateView()
    }
    
    func setIndex(index: Int) {
        buttons.forEach {
            $0.setTitleColor(textColor, for: .normal)
        }
        let button = buttons[index]
        selectedIndex = index
        button.setTitleColor(selectorTextColor, for: .normal)
        let selectorPosition = frame.width / CGFloat(buttonTitles.count) * CGFloat(index)
        UIView.animate(withDuration: 0.2) {
            self.selectorView.frame.origin.x = selectorPosition
        }
    }
    
    @objc private func buttonAction(_ sender: UIButton) {
        for (index, button) in buttons.enumerated() {
            button.setTitleColor(textColor, for: .normal)
            
            if button == sender {
                let selectorPosition = frame.width / CGFloat(buttonTitles.count) * CGFloat(index)
                selectedIndex = index
                
                selectedButtonIndex.accept(index)
                
                UIView.animate(withDuration: 0.2) {
                    self.selectorView.frame.origin.x = selectorPosition
                }
                
                button.setTitleColor(selectorTextColor, for: .normal)
            }
        }
    }
     
    private func updateView() {
        createButtons()
        configureSelectorView()
        configureStackView()
    }
    
    private func createButtons() {
        buttons.removeAll()
        
        subviews.forEach {
            $0.removeFromSuperview()
        }
        
        for buttonTitle in buttonTitles {
            let button = UIButton(type: .system).then {
                $0.setTitle(buttonTitle, for: .normal)
                $0.setTitleColor(textColor, for: .normal)
                $0.titleLabel?.minimumScaleFactor = 0.5
                $0.titleLabel?.adjustsFontSizeToFitWidth = true
            }
            
            buttons.append(button)
            
            button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
            
            buttons[0].setTitleColor(selectorTextColor, for: .normal)
        }
        
        selectedIndex = 0
        selectedButtonIndex.accept(0)
    }
    
    private func configureStackView() {
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureSelectorView() {
        let selectorWidth = frame.width / CGFloat(self.buttonTitles.count)
        
        selectorView = UIView(frame: CGRect(x: 0, y: self.frame.height, width: selectorWidth, height: 2))
        selectorView.backgroundColor = selectorViewColor
        
        addSubview(selectorView)
    }
}
