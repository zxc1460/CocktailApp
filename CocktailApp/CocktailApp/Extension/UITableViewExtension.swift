//
//  TableView.swift
//  CocktailApp
//
// 

import UIKit
import SnapKit

extension UITableView {
    var contentsHeight: CGFloat {
        get {
            return self.contentSize.height
        }
        set {
            self.snp.updateConstraints {
                $0.height.equalTo(newValue)
            }
        }
    }
}
