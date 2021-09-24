//
//  UIColor.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/24.
//

import UIKit

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexString: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            
        if (hexString.hasPrefix("#")) {
            hexString = String(hexString.dropFirst())
        }
        assert(hexString.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat((rgbValue & 0x0000FF)) / 255.0,
                  alpha: alpha)
    }
}
