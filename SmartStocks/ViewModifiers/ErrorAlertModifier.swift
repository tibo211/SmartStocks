//
//  ErrorAlertModifier.swift
//  SmartStocks
//
//  Created by Tibor Felföldy on 2023-05-07.
//

import SwiftUI

struct ErrorAlertModifier: ViewModifier {
    @Binding var error: Error?
    @Environment(\.dismiss) private var dismiss
    
    func body(content: Content) -> some View {
        content.alert("Error", isPresented: $error.optionalFlag()) {
            Button("Ok") {
                dismiss()
            }
        } message: {
            if let error {
                Text(error.localizedDescription)
            }
        }
    }
}

extension View {
    func alert(on error: Binding<Error?>) -> some View {
        modifier(ErrorAlertModifier(error: error))
    }
}
