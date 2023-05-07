//
//  Request.swift
//  
//
//  Created by Tibor Felföldy on 2023-05-07.
//

import Foundation

public protocol Request {
    associatedtype Result: Decodable

    var endpoint: String { get }
    var queryItems: [URLQueryItem] { get }
    var retry: Int { get }
}

public extension Request {
    var retry: Int { 3 }

    var url: URL {
        var components = URLComponents(string: API.Finnhub.basePath + endpoint)!
        let apiKeyQueryItem = URLQueryItem(name: "token", value: API.Finnhub.APIKey)
        components.queryItems = queryItems + [apiKeyQueryItem]
        return components.url!
    }
    
    func perform() async throws -> Result {
        let request = URLRequest(url: url)
        let (data, _) = try await API.perform(request: request, retry: retry)
        debug(.request, String(reflecting: self))
        return try JSONDecoder().decode(Result.self, from: data)
    }
}
