//
//  WebSocketController.swift
//  
//
//  Created by Tibor Felföldy on 2023-05-01.
//

import Foundation
import Combine

final class WebSocketController: NSObject, URLSessionWebSocketDelegate {
    let subject = PassthroughSubject<URLSessionWebSocketTask.Message, Never>()

    private let url: URL
    private let sessionRestarted: () -> Void
    private var socket: URLSessionWebSocketTask!

    init(url: URL, sessionRestarted: @escaping () -> Void) {
        self.url = url
        self.sessionRestarted = sessionRestarted
        super.init()
        startSession()
    }
    
    func startSession() {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        let session = URLSession(configuration: configuration,
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
                debug(.websocket, "ERROR: \(error.localizedDescription)")
                startSession()
                sessionRestarted()
                debug(.websocket, "session restarted")
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
