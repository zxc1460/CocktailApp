//
//  DateExtension.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/10/12.
//

import Foundation

extension DateFormatter {
    convenience init(format: String) {
        self.init()
        dateFormat = format
        timeZone = .autoupdatingCurrent
        locale = .current
    }
}

extension Date {
    func toString() -> String {
        return DateFormatter(format: "yyyy-MM-dd").string(from: self)
    }
}
