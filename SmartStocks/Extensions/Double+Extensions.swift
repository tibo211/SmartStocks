//
//  Double+Extensions.swift
//  SmartStocks
//
//  Created by Tibor Felföldy on 2023-05-02.
//

import Foundation

extension Double {
    func currencyString(showPlus: Bool = false, currency: String = "") -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency
        if currency.isEmpty {
            formatter.currencySymbol = ""
        }
        formatter.positivePrefix = (showPlus ? "+" : "") + formatter.positivePrefix
        formatter.negativePrefix = formatter.negativePrefix
        return formatter.string(from: NSNumber(value: self)) ?? "0"
    }
}
