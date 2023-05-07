//
//  File.swift
//  
//
//  Created by Tibor Felföldy on 2023-05-02.
//

import Foundation
import API

protocol Request {
    associatedtype Result: Decodable

    var endpoint: String { get }
    var queryItems: [URLQueryItem] { get }
    var retry: Int { get }
}

extension Request {
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
        #if DEBUG
        debug(.request, String(reflecting: self))
        #endif
        return try JSONDecoder().decode(Result.self, from: data)
    }
}
