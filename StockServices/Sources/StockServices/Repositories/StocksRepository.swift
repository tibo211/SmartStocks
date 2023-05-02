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
    func subscribe(symbol: String) async throws
    var priceUpdatePublisher: AnyPublisher<[StockPrice], Error> { get }
}

// MARK: - StocksRepository default implementation

final class DefaultStocksRepository: StocksRepository {
    private let socketController: WebSocketController
    
    init() {
        socketController = WebSocketController(url: API.finnhub.webSocketURL)
    }
    
    func quote(symbol: String) async throws -> QuoteResult {
        try await API.Finnhub.Quote(symbol: symbol).perform()
    }
    
    func subscribe(symbol: String) async throws {
        print("Subscribe to \(symbol)")
        let message = #"{"type":"subscribe","symbol":"\#(symbol)"}"#
        try await socketController.send(message: .string(message))
    }
    
    var priceUpdatePublisher: AnyPublisher<[StockPrice], Error> {
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
