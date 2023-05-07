//
//  SymbolLookup.swift
//  
//
//  Created by Tibor Felföldy on 2023-05-03.
//

import Foundation

public struct SymbolLookupResult: Decodable {
    public let result: [SymbolResult]
}

public struct SymbolResult: Decodable {
    public let description: String
    public let symbol: String
    
    public init(description: String, symbol: String) {
        self.description = description
        self.symbol = symbol
    }
}

public extension API.Finnhub {
    struct SymbolLookup: Request {
        public typealias Result = SymbolLookupResult
        
        let query: String

        public let endpoint = "search"
        
        public let retry = 1
        
        public var queryItems: [URLQueryItem] {
            [URLQueryItem(name: "q", value: query)]
        }
        
        public init(query: String) {
            self.query = query
        }
    }
}
