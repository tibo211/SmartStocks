//
//  StockPrice.swift
//  
//
//  Created by Tibor Felföldy on 2023-05-02.
//

import Foundation

struct StockPriceResults: Decodable {
    let data: [StockPrice]
}

public struct StockPrice: Decodable {
    public let symbol: String
    public let price: Double
    
    enum CodingKeys: String, CodingKey {
        case symbol = "s"
        case price = "p"
    }
    
    public init(symbol: String, price: Double) {
        self.symbol = symbol
        self.price = price
    }
}
