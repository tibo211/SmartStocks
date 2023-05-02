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

public struct StockPrice {
    public let symbol: String
    public let price: Double
    
    public init(symbol: String, price: Double) {
        self.symbol = symbol
        self.price = price
    }
}

extension StockPrice: Decodable {
    enum CodingKeys: CodingKey {
        case s, p
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        symbol = try container.decode(String.self, forKey: .s)
        price = try container.decode(Double.self, forKey: .p)
    }
}
