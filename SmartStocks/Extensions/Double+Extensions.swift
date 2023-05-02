//
//  Double+Extensions.swift
//  SmartStocks
//
//  Created by Tibor Felföldy on 2023-05-02.
//

import Foundation

extension Double {
    func currencyString(showPlus: Bool = false) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        formatter.positivePrefix = showPlus ? "+" : ""
        return formatter.string(from: NSNumber(value: self)) ?? "0"
    }
}
