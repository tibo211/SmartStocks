//
//  WebSocketController.swift
//  
//
//  Created by Tibor Felföldy on 2023-05-01.
//

import Foundation

final class WebSocketController: NSObject, URLSessionWebSocketDelegate {
    private var socket: URLSessionWebSocketTask!
    
    init(url: URL) {
        super.init()
        let session = URLSession(configuration: .default,
                                 delegate: self,
                                 delegateQueue: OperationQueue())
        let socket = session.webSocketTask(with: url)
        socket.resume()
    }
    
    func urlSession(_ session: URLSession,
                    webSocketTask: URLSessionWebSocketTask,
                    didOpenWithProtocol protocol: String?) {
        // TODO: Ping.
        // TODO: Loop to receive response.
    }
    
    func urlSession(_ session: URLSession,
                    webSocketTask: URLSessionWebSocketTask,
                    didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
                    reason: Data?) {
        print("WEBSOCKET closed.")
    }
}
