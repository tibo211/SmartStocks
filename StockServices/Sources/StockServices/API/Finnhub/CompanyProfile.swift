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
    
    enum CodingKeys: String, CodingKey {
        case name
        case logo
        case industry = "finnhubIndustry"
    }
    
    public init(name: String, logo: String, industry: String) {
        self.name = name
        self.logo = logo
        self.industry = industry
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
