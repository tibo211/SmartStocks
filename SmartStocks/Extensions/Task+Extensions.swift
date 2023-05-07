//
//  Task+Extensions.swift
//  SmartStocks
//
//  Created by Tibor Felföldy on 2023-05-07.
//

import SwiftUI

extension Task<Void, Never> {
    @discardableResult
    static func redirectError(_ catchError: Binding<Error?>, operation: @escaping () async throws -> Void) -> Task<Void, Never> {
        Task<Void, Never> {
            do {
                try await operation()
            } catch {
                DispatchQueue.main.async {
                    catchError.wrappedValue = error
                }
            }
        }
    }
}
