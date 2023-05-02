//
//  SmartStocksApp.swift
//  SmartStocks
//
//  Created by Tibor Felföldy on 2023-05-01.
//

import SwiftUI

@main
struct SmartStocksApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                StockList(model: StockListModel())
            }
        }
    }
}
