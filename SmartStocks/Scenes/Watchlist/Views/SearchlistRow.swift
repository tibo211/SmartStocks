//
//  SearchlistRow.swift
//  SmartStocks
//
//  Created by Tibor Felföldy on 2023-05-05.
//

import SwiftUI
import StockServices

struct SearchlistRow: View {
    let item: Symbol
    let action: () -> Void

    @Environment(\.dismissSearch) private var dismissSearch

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.symbol)
                    .font(.headline)
                Text(item.description)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button {
                action()
                dismissSearch()
            } label: {
                Label("Add", systemImage: "plus.circle")
                    .foregroundColor(.red)
            }
        }
    }
}

struct SearchlistRow_Previews: PreviewProvider {
    static var previews: some View {
        SearchlistRow(item: Symbol(description: "Apple Inc", symbol: "AAPL")) {}
    }
}
