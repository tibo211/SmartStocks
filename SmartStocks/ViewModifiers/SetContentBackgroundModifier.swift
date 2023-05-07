//
//  SetContentBackgroundModifier.swift
//  SmartStocks
//
//  Created by Tibor Felföldy on 2023-05-07.
//

import SwiftUI

struct SetContentBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            #if os(macOS)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(nsColor: .controlBackgroundColor))
            #endif
    }
}

extension View {
    func setContentBackground() -> some View {
        modifier(SetContentBackgroundModifier())
    }
}

struct SetContentBackgroundModifier_Previews: PreviewProvider {
    static var previews: some View {
        Text("mac with normal bg color")
            .setContentBackground()
    }
}
