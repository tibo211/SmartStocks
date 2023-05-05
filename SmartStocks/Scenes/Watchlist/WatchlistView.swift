//
//  WatchlistView.swift
//  SmartStocks
//
//  Created by Tibor Felföldy on 2023-05-02.
//

import SwiftUI

struct WatchlistView: View {
    @ObservedObject var searchController: SearchController
    @StateObject var model: WatchlistViewModel
    @Environment(\.isSearching) private var isSearching
    @Environment(\.dismissSearch) private var dismissSearch
    
    var body: some View {
        ZStack {
            List {
                ForEach(model.symbols, id: \.self) { symbol in
                    if let item = model.items[symbol] {
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
                    } else {
                        Text(symbol)
                    }
                }
                .onDelete(perform: model.delete)
            }
            
            if isSearching {
                List(searchController.searchResults, id: \.symbol) { result in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(result.symbol)
                                .font(.headline)
                            Text(result.description)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button {
                            Task {
                                try await model.add(symbol: result.symbol)
                            }
                            dismissSearch()
                        } label: {
                            Label("Add", systemImage: "plus.circle")
                                .foregroundColor(.red)
                        }
                    }
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
            WatchlistView(searchController: SearchController(), model: WatchlistViewModel())
        }
    }
}
