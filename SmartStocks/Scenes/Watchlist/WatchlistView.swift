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
                            WatchlistRow(item: item)
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
}

struct StockList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WatchlistView(searchController: SearchController(), model: WatchlistViewModel())
        }
    }
}
