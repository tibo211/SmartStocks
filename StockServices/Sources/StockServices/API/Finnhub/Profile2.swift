//
//  Profile2.swift
//  
//
//  Created by Tibor Felföldy on 2023-05-02.
//

import Foundation

struct CompanyProfileResult: Decodable {
    let name: String
    let logo: String
    let industry: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case logo
        case industry = "finnhubIndustry"
    }
}

extension API.Finnhub {
    public struct Profile2: Request {
        typealias Result = CompanyProfileResult
        let symbol: String
        
        let endpoint = "stock/profile2"
        
        var queryItems: [URLQueryItem] {
            [URLQueryItem(name: "symbol", value: symbol)]
        }
    }
}
