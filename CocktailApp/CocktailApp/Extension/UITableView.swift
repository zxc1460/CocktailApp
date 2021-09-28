//
//  TableView.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/28.
//

import UIKit
import SnapKit

extension UITableView {
    var height: CGFloat {
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
