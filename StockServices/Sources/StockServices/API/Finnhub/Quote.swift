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

extension API.Finnhub {
    struct Quote: Request {
        typealias Result = QuoteResult
        let symbol: String
        
        let endpoint = "quote"
        
        var queryItems: [URLQueryItem] {
            [URLQueryItem(name: "symbol", value: symbol)]
        }
    }
}
