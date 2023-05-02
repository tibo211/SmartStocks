//
//  Debug.swift
//  
//
//  Created by Tibor Felföldy on 2023-05-02.
//

import Foundation

enum LogType: String {
    case websocket = "🌐 WEBSOCKET"
    case request = "🌐 REQUEST"
}

func debug(_ type: LogType, _ message: String) {
    #if DEBUG
    print("\(type.rawValue) - \(message)")
    #endif
}
