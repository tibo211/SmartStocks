//
//  StockList.swift
//  SmartStocks
//
//  Created by Tibor Felföldy on 2023-05-02.
//

import SwiftUI

struct StockList: View {
    @ObservedObject var model: StockListModel
    private let gridItem = GridItem(.adaptive(minimum: 240), alignment: .top)
    
    var body: some View {
        List(model.items) { item in
            HStack {
                Text(item.symbol)
                    .font(.title)
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(item.price.currencyString)")
                    Text("\(item.difference.currencyString)")
                        .font(.caption)
                        .padding(4)
                        .background(color(for: item.difference))
                        .clipShape(Capsule())
                }
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.thinMaterial)
            }
        }
        .task {
            do {
                try await model.loadQuotes()
            } catch {
                print(error)
            }
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

struct StockList_Previews: PreviewProvider {
    static var previews: some View {
        StockList(model: StockListModel(stocksService: PreviewStocksRepository()))
    }
}
