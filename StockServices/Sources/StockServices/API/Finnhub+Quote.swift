//
//  Finnhub+Quote.swift
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
}

extension API.Finnhub {
    struct Quote: Request {
        typealias Result = QuoteResult
        let endpoint = "quote"
        let symbol: String
        
        var queryItems: [URLQueryItem] {
            [URLQueryItem(name: "symbol", value: symbol)]
        }
    }
}
