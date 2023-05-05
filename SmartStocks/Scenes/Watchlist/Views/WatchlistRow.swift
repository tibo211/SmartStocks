//
//  WatchlistRow.swift
//  SmartStocks
//
//  Created by Tibor Felföldy on 2023-05-05.
//

import SwiftUI

struct WatchlistRow: View {
    let item: StockItem
    
    var body: some View {
        HStack {
            Text(item.symbol)
                .font(.headline)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(item.price.currencyString())")
                Text("\(item.difference.currencyString(showPlus: true))")
                    .font(.caption).bold()
                    .foregroundColor(color(for: item.difference))
                    .padding(2)
                    .background {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.thinMaterial)
                    }
            }
            .monospaced()
        }
    }

    private func color(for difference: Double) -> Color {
        switch difference {
        case 0:
            return .clear
        case let x where x < 0:
            return .red
        default:
            return .green
        }
    }
}

struct WatchlistRow_Previews: PreviewProvider {
    static var previews: some View {
        WatchlistRow(item: StockItem(symbol: "AAPL", price: 169, closePrice: 165))
    }
}
