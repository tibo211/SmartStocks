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
    @State private var error: Error?
    
    var body: some View {
        ZStack {
            if isSearching {
                List(searchController.searchResults, id: \.symbol) { result in
                    SearchlistRow(item: result) {
                        Task.redirectError($error) {
                            try await model.add(symbol: result.symbol)
                        }
                    }
                }
            } else {
                List {
                    ForEach(model.symbols, id: \.self) { symbol in
                        if let item = model.items[symbol] {
                            NavigationLink {
                                CompanyDetailsView(viewModel: CompanyDetailsViewModel(symbol: item.symbol, price: item.price))
                            } label: {
                                WatchlistRow(item: item)
                            }
                        } else {
                            Text(symbol)
                        }
                    }
                    .onDelete(perform: model.delete)
                }
            }
        }
        .awaitAndCatch {
            try await model.loadQuotes()
        }
        .alert(on: $error)
        .navigationTitle("Watchlist")
    }
}

struct StockList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WatchlistView(searchController: SearchController(), model: WatchlistViewModel())
        }
    }
}
