//
//  UserRepository.swift
//  
//
//  Created by Tibor Felföldy on 2023-05-05.
//

import Foundation

public final class UserRepository {
    private let defaultSymbols = ["AAPL", "TSLA", "MSFT"]
    private let defaultFinnhubAPIKey = "ch844ahr01qhapm5k2tgch844ahr01qhapm5k2u0"
    
    public var symbols: [String] {
        get {
            guard let stored = UserDefaults.standard.array(forKey: "symbols") as? [String] else {
                UserDefaults.standard.set(defaultSymbols, forKey: "symbols")
                return defaultSymbols
            }
            return stored
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "symbols")
        }
    }
    
    public var finnhubAPIKey: String {
        get {
            guard let stored = UserDefaults.standard.string(forKey: "finnhub") else {
                UserDefaults.standard.set(defaultFinnhubAPIKey, forKey: "finnhub")
                return defaultFinnhubAPIKey
            }
            return stored
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "symbols")
        }
    }
}
