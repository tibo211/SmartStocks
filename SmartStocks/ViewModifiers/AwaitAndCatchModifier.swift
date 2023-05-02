//
//  AwaitAndCatchModifier.swift
//  SmartStocks
//
//  Created by Tibor Felföldy on 2023-05-02.
//

import SwiftUI

struct AwaitAndCatchModifier: ViewModifier {
    let block: () async throws -> Void
    
    @State private var isErrorAlertPresented = false
    @State private var error: Error?
    @Environment(\.dismiss) private var dismiss
    
    func body(content: Content) -> some View {
        content
            .task {
                do {
                    try await block()
                } catch {
                    DispatchQueue.main.async {
                        self.error = error
                        isErrorAlertPresented = true
                    }
                }
            }
            .alert("Error", isPresented: $isErrorAlertPresented) {
                Button("Ok") {
                    dismiss()
                }
            } message: {
                Text(error?.localizedDescription ?? "Something went wrong")
            }
    }
}

extension View {
    func awaitAndCatch(block: @escaping () async throws -> Void) -> some View {
        modifier(AwaitAndCatchModifier(block: block))
    }
}
