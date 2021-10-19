//
//  UIViewControllerExtension.swift
//  CocktailApp
//
//

import UIKit
import Then

extension UIViewController {
    func showToast(message: String) {
        view.subviews
            .compactMap { $0 as? ToastLabel }
            .forEach { label in
                label.removeFromSuperview()
            }
                
        let toastLabel = ToastLabel().then {
            $0.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            $0.textColor = .white
            $0.textAlignment = .center
            $0.font = UIFont.systemFont(ofSize: 14)
            $0.text = message
            $0.alpha = 1.0
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 10
        }
        
        let textSize = toastLabel.intrinsicContentSize
        let width = min(textSize.width + 30, view.frame.size.width - 40)
        let height = textSize.height + 20
        
        toastLabel.frame = CGRect(x: 20,
                                  y: view.frame.height - 140,
                                  width: width,
                                  height: height)
        toastLabel.center.x = view.center.x
        
        view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 5.0, delay: 0.1, options: .curveEaseInOut) {
            toastLabel.alpha = 0.0
        } completion: { _ in
            toastLabel.removeFromSuperview()
        }
    }
    
    func showAlert(
        title: String?,
        message: String?,
        actionHandler: @escaping () -> Void,
        cancelHandler: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        ).then {
            let okAction = UIAlertAction(title: "확인", style: .default) { _ in
                actionHandler()
            }
            
            let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
                cancelHandler?()
            }
            
            $0.addAction(okAction)
            $0.addAction(cancelAction)
        }
        
        self.present(alert, animated: true)
    }
}
