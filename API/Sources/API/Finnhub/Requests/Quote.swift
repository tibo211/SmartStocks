//
//  Quote.swift
//  
//
//  Created by Tibor Felföldy on 2023-05-02.
//

import Foundation

public struct QuoteResult: Decodable {
    public let currentPrice: Double
    public let previousClosePrice: Double
    
    enum CodingKeys: String, CodingKey {
        case currentPrice = "c"
        case previousClosePrice = "pc"
    }
    
    public init(currentPrice: Double, previousClosePrice: Double) {
        self.currentPrice = currentPrice
        self.previousClosePrice = previousClosePrice
    }
}

public extension API.Finnhub {
    struct Quote: Request {
        public typealias Result = QuoteResult
        let symbol: String
        
        public let endpoint = "quote"
        
        public var queryItems: [URLQueryItem] {
            [URLQueryItem(name: "symbol", value: symbol)]
        }
        
        public init(symbol: String) {
            self.symbol = symbol
        }
    }
}
