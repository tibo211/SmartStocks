//
//  StocksRepository.swift
//  
//
//  Created by Tibor Felföldy on 2023-05-02.
//

import Combine
import Foundation

// MARK: - StocksRepository protocol

public protocol StocksRepository {
    func quote(symbol: String) async throws -> QuoteResult
    func companyProfile(symbol: String) async throws -> CompanyProfileResult
    func subscribe(symbols: Set<String>) async throws
    var priceUpdatePublisher: AnyPublisher<[String:Double], Never> { get }
}

// MARK: - StocksRepository default implementation

final class DefaultStocksRepository: StocksRepository {
    private var subscribedSymbols = Set<String>()
    
    private lazy var socketController: WebSocketController = {
        WebSocketController(url: API.finnhub.webSocketURL) { [unowned self] in
            Task {
                try await subscribe(symbols: subscribedSymbols)
            }
        }
    }()
    
    func quote(symbol: String) async throws -> QuoteResult {
        try await API.Finnhub.Quote(symbol: symbol).perform()
    }
    
    func companyProfile(symbol: String) async throws -> CompanyProfileResult {
        try await API.Finnhub.CompanyProfile(symbol: symbol).perform()
    }
    
    func subscribe(symbols: Set<String>) async throws {
        for symbol in symbols {
            let message = #"{"type":"subscribe","symbol":"\#(symbol)"}"#
            debug(.websocket, "send: \(message)")
            try await socketController.send(message: .string(message))
        }
        DispatchQueue.main.async {
            self.subscribedSymbols = symbols
        }
    }
    
    var priceUpdatePublisher: AnyPublisher<[String:Double], Never> {
        socketController.subject
            .compactMap { message -> [StockPrice]? in
                guard case let .string(value) = message,
                      let data = value.data(using: .utf8) else {
                    return nil
                }

                let result = try? JSONDecoder()
                    .decode(StockPriceResults.self, from: data)

                return result?.data
            }
            // Group symbols with their latest price.
            .map { Dictionary(grouping: $0, by: \.symbol).compactMapValues(\.last?.price) }
            // Combine with the last results to ensure that throttle
            // doesn't skip updates for symbols that didn't come with the latest publishing.
            .scan(([String:Double](), [String:Double]())) { lastResults, updates in
                let last = lastResults.1
                var newResults = last
                for update in updates {
                    newResults[update.key] = update.value
                }
                return (last, newResults)
            }
            .map { $1 }
            .removeDuplicates()
            // Throttle to ensure that the main thread is not overloaded
            // with too many events being processed at once.
            .throttle(for: .seconds(1), scheduler: RunLoop.main, latest: true)
            .handleEvents(receiveOutput: { updates in
                debug(.websocket, "price updates: \(updates)")
            })
            .eraseToAnyPublisher()
    }
}
