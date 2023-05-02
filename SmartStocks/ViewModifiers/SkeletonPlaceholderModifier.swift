//
//  SkeletonPlaceholderModifier.swift
//  SmartStocks
//
//  Created by Tibor Felföldy on 2023-05-02.
//

import SwiftUI

struct SkeletonPlaceholderModifier: ViewModifier {
    let isPlaceholder: Bool
    
    func body(content: Content) -> some View {
        Group {
            if isPlaceholder {
                content.redacted(reason: .placeholder)
            } else {
                content
            }
        }
        .animation(.default, value: isPlaceholder)
    }
}

extension View {
    func skeletonPlaceholder(_ isPlaceholder: Bool) -> some View {
        modifier(SkeletonPlaceholderModifier(isPlaceholder: isPlaceholder))
    }
}

struct SkeletonModifier_Previews: PreviewProvider {
    static var previews: some View {
        Text("Refracted")
            .skeletonPlaceholder(true)
    }
}
