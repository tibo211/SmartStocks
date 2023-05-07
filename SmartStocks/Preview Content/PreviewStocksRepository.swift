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
        "AAPL": Quote(currentPrice: 169.59, previousClosePrice: 169.68)
    ]
    
    private let profiles = [
        "AAPL": CompanyProfile(name: "Apple Inc.", logo: "https://static.finnhub.io/logo/87cb30d8-80df-11ea-8951-00000000092a.png", industry: "Technology", currency: "USD", exchange: "NASDAQ")
    ]
    
    func symbolLookup(query: String) async throws -> [Symbol] {
        if let (key, profile) = profiles.first(where: { $0.key.starts(with: query) }) {
            return [Symbol(description: profile.name, symbol: key)]
        }
        return []
    }
    
    func quote(symbol: String) async throws -> Quote {
        initalQuotes[symbol] ?? Quote(currentPrice: .random(in: 10...100), previousClosePrice: .random(in: 10...100))
    }
    
    func companyProfile(symbol: String) async throws -> CompanyProfile {
        profiles[symbol] ?? CompanyProfile(name: "Unknown", logo: "", industry: "Technology", currency: "", exchange: "")
    }
    
    func stockCandles(symbol: String, from: Date, to: Date) async throws -> Candle {
        Candle(closes: [], timestamps: [])
    }
    
    func subscribe(symbols: Set<String>) async throws {}
    
    var priceUpdatePublisher: AnyPublisher<[String:Double], Never> {
        Timer.publish(every: 2, on: RunLoop.main, in: .default)
            .autoconnect()
            .map { _ in
                self.initalQuotes.mapValues {
                    $0.previousClosePrice + .random(in: -0.1...0.1)
                }
            }
            .eraseToAnyPublisher()
    }
}
