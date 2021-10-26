//
//  UIImageView.swift
//  CocktailApp
//
//

import UIKit
import Kingfisher

extension UIImageView {
    func setCocktailImage(_ urlString: String?) {
        if let urlString = urlString, let url = URL(string: urlString) {
            self.kf.setImage(with: url)
        } else {
            self.image = .baseThumbnailImage
        }
    }
}
