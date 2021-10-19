//
//  DateExtension.swift
//  CocktailApp
//
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
