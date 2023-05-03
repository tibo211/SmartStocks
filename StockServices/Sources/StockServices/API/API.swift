//
//  File.swift
//  
//
//  Created by Tibor Felföldy on 2023-05-02.
//

import Foundation

enum API {
    static let finnhub = Finnhub()

    private static let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        return URLSession(configuration: configuration)
    }()
    
    static func perform(request: URLRequest, retry: Int) async throws -> (Data, URLResponse) {
        for _ in 0..<retry {
            do {
                return try await session.data(for: request)
            } catch {
                continue
            }
        }
        return try await session.data(for: request)
    }
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
    var retry: Int { get }
}

extension Request {
    var retry: Int { 3 }

    var url: URL {
        var components = URLComponents(string: API.finnhub.basePath + endpoint)!
        let apiKeyQueryItem = URLQueryItem(name: "token", value: API.finnhub.apiKey)
        components.queryItems = queryItems + [apiKeyQueryItem]
        return components.url!
    }
    
    func perform() async throws -> Result {
        let request = URLRequest(url: url)
        let (data, _) = try await API.perform(request: request, retry: retry)
        #if DEBUG
        debug(.request, String(reflecting: self))
        #endif
        return try JSONDecoder().decode(Result.self, from: data)
    }
}
