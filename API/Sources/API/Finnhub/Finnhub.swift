//
//  Finnhub.swift
//  
//
//  Created by Tibor Felföldy on 2023-05-07.
//

import Foundation

extension API {
    public enum Finnhub {
        public static var APIKey: String = ""
        public static let basePath = "https://finnhub.io/api/v1/"

        public static var webSocketURL: URL {
            URL(string: "wss://ws.finnhub.io?token=\(Finnhub.APIKey)")!
        }
    }
}
