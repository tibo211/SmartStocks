//
//  UserRepository.swift
//  
//
//  Created by Tibor Felföldy on 2023-05-05.
//

import Foundation

public final class UserRepository {
    private let defaultSymbols = ["AAPL", "TSLA", "MSFT"]
    
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
}
