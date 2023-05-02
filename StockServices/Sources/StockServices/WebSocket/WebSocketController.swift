//
//  WebSocketController.swift
//  
//
//  Created by Tibor Felföldy on 2023-05-01.
//

import Foundation
import Combine

final class WebSocketController: NSObject, URLSessionWebSocketDelegate {
    let subject = PassthroughSubject<URLSessionWebSocketTask.Message, Error>()

    private var socket: URLSessionWebSocketTask!

    init(url: URL) {
        super.init()
        let session = URLSession(configuration: .default,
                                 delegate: self,
                                 delegateQueue: OperationQueue())
        socket = session.webSocketTask(with: url)
        socket.resume()
    }
    
    func send(message: URLSessionWebSocketTask.Message) async throws {
        try await socket.send(message)
    }
    
    func urlSession(_ session: URLSession,
                    webSocketTask: URLSessionWebSocketTask,
                    didOpenWithProtocol protocol: String?) {
        debug(.websocket, "session opened")
        Task {
            do {
                try await ping()

                while socket.state == .running {
                    let message = try await socket.receive()
                    debug(.websocket, "\(message)")
                    subject.send(message)
                }
            } catch {
                subject.send(completion: .failure(error))
            }
        }
    }
    
    func urlSession(_ session: URLSession,
                    webSocketTask: URLSessionWebSocketTask,
                    didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
                    reason: Data?) {
        debug(.websocket, "session closed")
    }
    
    private func ping() async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) -> Void in
            socket.sendPing { error in
                if let error {
                    continuation.resume(with: .failure(error))
                } else {
                    debug(.websocket, "pong")
                    continuation.resume()
                }
            }
        }
    }
}
