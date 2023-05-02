//
//  ServiceProvider.swift
//  SmartStocks
//
//  Created by Tibor Felföldy on 2023-05-02.
//

import Foundation
import StockServices

struct ServiceProvider {    
    static let stocksService: StocksRepository = {
        #if DEBUG
        if ProcessInfo.isRunningForPreviews {
            return PreviewStocksRepository()
        }
        #endif
        return StockServices.repository
    }()
}

