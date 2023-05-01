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
    func subscribe(symbol: String) async throws
}

// MARK: - StocksRepository default implementation

final class DefaultStocksRepository: StocksRepository {
    private let socketController: WebSocketController
    
    init() {
        let apiKey = "ch844ahr01qhapm5k2tgch844ahr01qhapm5k2u0"
        let url = URL(string: "wss://ws.finnhub.io?token=\(apiKey)")!
        socketController = WebSocketController(url: url)
    }
    
    func subscribe(symbol: String) async throws {
        let message = #"{"type":"subscribe","symbol":"\#(symbol)"}"#
        try await socketController.send(message: .string(message))
    }
}
