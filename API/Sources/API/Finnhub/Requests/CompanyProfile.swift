//
//  Profile2.swift
//  
//
//  Created by Tibor Felföldy on 2023-05-02.
//

import Foundation

public struct CompanyProfileResult: Decodable {
    public let name: String
    public let logo: String
    public let industry: String
    public let currency: String
    public let exchange: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case logo
        case industry = "finnhubIndustry"
        case currency
        case exchange
    }
    
    public init(name: String, logo: String, industry: String, currency: String, exchange: String) {
        self.name = name
        self.logo = logo
        self.industry = industry
        self.currency = currency
        self.exchange = exchange
    }
}

public extension API.Finnhub {
    struct CompanyProfile: Request {
        public typealias Result = CompanyProfileResult
        let symbol: String
        
        public let endpoint = "stock/profile2"
        
        public var queryItems: [URLQueryItem] {
            [URLQueryItem(name: "symbol", value: symbol)]
        }
        
        public init(symbol: String) {
            self.symbol = symbol
        }
    }
}
