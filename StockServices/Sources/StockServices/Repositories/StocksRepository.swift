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
    var priceUpdatePublisher: AnyPublisher<[StockPrice], Never> { get }
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
    
    var priceUpdatePublisher: AnyPublisher<[StockPrice], Never> {
        socketController.subject
            .compactMap { message in
                guard case let .string(value) = message,
                      let data = value.data(using: .utf8) else {
                    return nil
                }

                let result = try? JSONDecoder()
                    .decode(StockPriceResults.self, from: data)

                guard let stocks = result?.data else {
                    return nil
                }
                let stockPrices = Dictionary(grouping: stocks, by: \.symbol)
                    .compactMapValues(\.last)
                    .values
                    
                return Array(stockPrices)
            }
            .eraseToAnyPublisher()
    }
}
