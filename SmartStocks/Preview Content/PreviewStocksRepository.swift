//
//  PreviewStocksRepository.swift
//  SmartStocks
//
//  Created by Tibor Felföldy on 2023-05-02.
//

import StockServices
import Combine
import Foundation

final class PreviewStocksRepository: StocksRepository {
    private let initalQuotes = [
        "AAPL": QuoteResult(currentPrice: 169.59, previousClosePrice: 169.68)
    ]
    
    private let profiles = [
        "AAPL": CompanyProfileResult(name: "Apple Inc.", logo: "https://static.finnhub.io/logo/87cb30d8-80df-11ea-8951-00000000092a.png", industry: "Technology")
    ]
    
    func quote(symbol: String) async throws -> QuoteResult {
        initalQuotes[symbol] ?? QuoteResult(currentPrice: .random(in: 10...100), previousClosePrice: .random(in: 10...100))
    }
    
    func companyProfile(symbol: String) async throws -> CompanyProfileResult {
        profiles[symbol] ?? CompanyProfileResult(name: "Unknown", logo: "", industry: "Technology")
    }
    
    func subscribe(symbol: String) async throws {}
    
    var priceUpdatePublisher: AnyPublisher<[StockPrice], Error> {
        Timer.publish(every: 2, on: RunLoop.main, in: .default)
            .autoconnect()
            .map { _ in
                self.initalQuotes.map { symbol, quote in
                    StockPrice(
                        symbol: symbol,
                        price: quote.previousClosePrice + .random(in: -0.1...0.1)
                    )
                }
            }
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
