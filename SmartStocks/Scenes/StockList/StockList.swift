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
            NavigationLink {
                StockDetailsView(viewModel: StockDetailsViewModel(symbol: item.symbol, price: item.price))
            } label: {
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
        }
        .awaitAndCatch {
            try await model.loadQuotes()
        }
        .navigationTitle("Watchlist")
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
        NavigationView {
            StockList(model: StockListModel(stocksService: PreviewStocksRepository()))
        }
    }
}
