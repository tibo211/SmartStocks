//
//  File.swift
//  
//
//  Created by Tibor Felföldy on 2023-05-02.
//

import Foundation

enum API {
    static let finnhub = Finnhub()
}

extension API {
    struct Finnhub {
        fileprivate let apiKey = "ch844ahr01qhapm5k2tgch844ahr01qhapm5k2u0"
        fileprivate let basePath = "https://finnhub.io/api/v1/"
        
        var webSocketURL: URL {
            URL(string: "wss://ws.finnhub.io?token=\(apiKey)")!
        }
    }
}

protocol Request {
    associatedtype Result: Decodable

    var endpoint: String { get }
    var queryItems: [URLQueryItem] { get }
}

extension Request {
    var url: URL {
        var components = URLComponents(string: API.finnhub.basePath + endpoint)!
        let apiKeyQueryItem = URLQueryItem(name: "token", value: API.finnhub.apiKey)
        components.queryItems = queryItems + [apiKeyQueryItem]
        return components.url!
    }
    
    func perform() async throws -> Result {
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(Result.self, from: data)
    }
}
