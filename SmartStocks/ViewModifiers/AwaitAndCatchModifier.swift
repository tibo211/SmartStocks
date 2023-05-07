//
//  AwaitAndCatchModifier.swift
//  SmartStocks
//
//  Created by Tibor Felföldy on 2023-05-02.
//

import SwiftUI

struct AwaitAndCatchModifier: ViewModifier {
    let block: () async throws -> Void
    
    @State private var error: Error?
    @Environment(\.dismiss) private var dismiss
    
    func body(content: Content) -> some View {
        content
            .task {
                Task.redirectError($error) {
                    try await block()
                }
            }
            .alert(on: $error)
    }
}

extension View {
    func awaitAndCatch(block: @escaping () async throws -> Void) -> some View {
        modifier(AwaitAndCatchModifier(block: block))
    }
}
