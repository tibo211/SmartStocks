//
//  CompanyDetailsViewModel.swift
//  SmartStocks
//
//  Created by Tibor Felföldy on 2023-05-02.
//

import Foundation
import StockServices

struct CandleData {
    let time: Date
    let closePrice: Double
}

final class CompanyDetailsViewModel: ObservableObject {
    let symbol: String
    @Published private(set) var price: Double
    @Published private(set) var company: CompanyProfile?
    @Published private(set) var chartData: [CandleData]?
    
    var logoUrl: URL? {
        guard let link = company?.logo else {
            return nil
        }
        return URL(string: link)
    }
    
    init(symbol: String, price: Double) {
        self.symbol = symbol
        self.price = price
    }
    
    func loadCompanyDetails() async throws {
        let companyProfile = try await ServiceProvider.stocksService
            .companyProfile(symbol: symbol)

        DispatchQueue.main.async {
            self.company = companyProfile
        }
    }
    
    func loadChart() async throws {
        let from = Calendar.current.date(byAdding: .month, value: -2, to: Date())!
        let to = Date()
        
        let candles = try await ServiceProvider.stocksService
            .stockCandles(symbol: symbol, from: from, to: to)
        
        let candleData = zip(candles.closes, candles.timestamps).map { price, time in
            CandleData(time: time, closePrice: price)
        }
        
        DispatchQueue.main.async {
            self.chartData = candleData
        }
    }
    
    func priceUpdates(_ updates: [String: Double]) {
        if let newPrice = updates[symbol] {
            price = newPrice
        }
    }
}
