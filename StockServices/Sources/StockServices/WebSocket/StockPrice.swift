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

 struct StockPrice: Decodable {
    let symbol: String
    let price: Double
    
    enum CodingKeys: String, CodingKey {
        case symbol = "s"
        case price = "p"
    }
}
