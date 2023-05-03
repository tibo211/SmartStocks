//
//  SymbolLookup.swift
//  
//
//  Created by Tibor Felföldy on 2023-05-03.
//

import Foundation

struct SymbolLookupResult: Decodable {
    let result: [SymbolResult]
}

public struct SymbolResult: Decodable {
    public let description: String
    public let symbol: String
    
    public init(description: String, symbol: String) {
        self.description = description
        self.symbol = symbol
    }
}

extension API.Finnhub {
    struct SymbolLookup: Request {
        typealias Result = SymbolLookupResult
        
        let query: String

        let endpoint = "search"
        
        let retry = 1
        
        var queryItems: [URLQueryItem] {
            [URLQueryItem(name: "q", value: query)]
        }
    }
}
