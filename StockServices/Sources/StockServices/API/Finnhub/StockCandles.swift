//
//  StockCandles.swift
//  
//
//  Created by Tibor Felföldy on 2023-05-05.
//

import Foundation

public struct CandleResult: Decodable {
    public let closes: [Double]
    public let timestamps: [Date]
    
    enum CodingKeys: String, CodingKey {
        case closes = "c"
        case timestamps = "t"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        closes = try container.decode([Double].self, forKey: .closes)
        timestamps = try container.decode([Double].self, forKey: .timestamps)
            .map { timestamp in
                Date(timeIntervalSince1970: timestamp)
            }
    }
    
    public init(closes: [Double], timestamps: [Date]) {
        self.closes = closes
        self.timestamps = timestamps
    }
}

extension API.Finnhub {
    struct StockCandles: Request {
        typealias Result = CandleResult
        
        let symbol: String
        let from: Date
        let to: Date
        
        let endpoint = "stock/candle"
        
        var queryItems: [URLQueryItem] {
            [
                URLQueryItem(name: "symbol", value: symbol),
                URLQueryItem(name: "resolution", value: "D"),
                URLQueryItem(name: "from", value: String(Int(from.timeIntervalSince1970))),
                URLQueryItem(name: "to", value: String(Int(to.timeIntervalSince1970)))
            ]
        }
    }
}
