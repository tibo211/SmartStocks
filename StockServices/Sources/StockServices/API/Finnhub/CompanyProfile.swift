//
//  Profile2.swift
//  
//
//  Created by Tibor Felföldy on 2023-05-02.
//

import Foundation
import API

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

extension API.Finnhub {
    public struct CompanyProfile: Request {
        typealias Result = CompanyProfileResult
        let symbol: String
        
        let endpoint = "stock/profile2"
        
        var queryItems: [URLQueryItem] {
            [URLQueryItem(name: "symbol", value: symbol)]
        }
    }
}
