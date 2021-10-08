//
//  UnderlineSegmentedControl.swift
//  CocktailApp
//
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class UnderlineSegmentedControl: UIView {
    
    // MARK: - Properties
    
    private var buttonTitles = [String]()
    private var buttons = [UIButton]()
    private var selectorView: UIView!
    
    var textColor = UIColor.black
    var selectorViewColor = UIColor.systemBlue
    var selectorTextColor = UIColor.systemBlue
        
    var selectedButtonIndex = BehaviorRelay<Int>(value: 0)
    
    let disposeBag = DisposeBag()
    
    // MARK: - init Method
    
    convenience init(buttonTitles: [String]) {
        self.init(frame: .zero)
        self.buttonTitles = buttonTitles
        
        updateView()
        
        selectedButtonIndex
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { owner, index in
                owner.selectSegment(of: index)
            })
            .disposed(by: disposeBag)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.backgroundColor = .white
        
        updateView()
    }
    
    // MARK: - Private Methods
    
    private func selectSegment(of index: Int) {
        buttons.forEach {
            $0.setTitleColor(textColor, for: .normal)
        }
        
        let button = buttons[index]
            
        button.setTitleColor(selectorTextColor, for: .normal)
        
        let selectorPosition = frame.width / CGFloat(buttonTitles.count) * CGFloat(index)
        
        UIView.animate(withDuration: 0.2) {
            self.selectorView.frame.origin.x = selectorPosition
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
        
        for (index, buttonTitle) in buttonTitles.enumerated() {
            let button = UIButton(type: .system).then {
                $0.setTitle(buttonTitle, for: .normal)
                $0.setTitleColor(textColor, for: .normal)
                $0.titleLabel?.minimumScaleFactor = 0.5
                $0.titleLabel?.adjustsFontSizeToFitWidth = true
            }
            
            buttons.append(button)
            
            button.tag = index
            
            buttons[0].setTitleColor(selectorTextColor, for: .normal)
        }
        
        let obs = buttons
            .map { ($0.rx.tap, $0.tag) }
            .map { ob, tag in
                ob.map { tag }
            }
        
        Observable.merge(obs)
            .bind(to: selectedButtonIndex)
            .disposed(by: disposeBag)
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
