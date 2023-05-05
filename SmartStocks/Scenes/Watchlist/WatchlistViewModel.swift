//
//  WatchlistViewModel.swift
//  SmartStocks
//
//  Created by Tibor Felföldy on 2023-05-02.
//

import Foundation
import StockServices
import Combine

struct StockItem: Identifiable {
    let symbol: String
    var price: Double
    let closePrice: Double
    
    var id: String { symbol }
    
    var difference: Double {
        price - closePrice
    }
}

final class WatchlistViewModel: ObservableObject {
    @Published private(set) var symbols: [String]
    @Published private(set) var items = [String: StockItem]()

    private let stocksService = ServiceProvider.stocksService
    private var isLoaded = false
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        symbols = StockServices.user.symbols
        
        stocksService.priceUpdatePublisher.sink { [unowned self] updates in
            for (symbol, price) in updates {
                items[symbol]?.price = price
            }
        }
        .store(in: &subscriptions)
    }

    func loadQuotes() async throws {
        guard !isLoaded else { return }
        let items = try await withThrowingTaskGroup(of: StockItem.self) { group in
            for symbol in symbols {
                group.addTask {
                    let quote = try await ServiceProvider.stocksService
                        .quote(symbol: symbol)
                    return StockItem(symbol: symbol,
                                     price: quote.currentPrice,
                                     closePrice: quote.previousClosePrice)
                }
            }
            
            var quotes = [StockItem]()
            quotes.reserveCapacity(symbols.count)
            for try await quote in group {
                quotes.append(quote)
            }
            return quotes
        }

        try await stocksService.subscribe(symbols: Set(symbols))

        DispatchQueue.main.async {
            self.items = Dictionary(grouping: items, by: \.symbol)
                .compactMapValues(\.last)
            self.isLoaded = true
        }
    }
    
    func add(symbol: String) async throws {
        if symbols.contains(symbol) { return }
        let quote = try await stocksService.quote(symbol: symbol)
        let stockItem = StockItem(symbol: symbol,
                                  price: quote.currentPrice,
                                  closePrice: quote.previousClosePrice)
        
        try await stocksService.subscribe(symbols: Set(symbols + [symbol]))
        
        DispatchQueue.main.async {
            self.items[symbol] = stockItem
            self.symbols.append(symbol)
            StockServices.user.symbols = self.symbols
        }
    }
    
    func delete(at offset: IndexSet) {
        symbols.remove(atOffsets: offset)
        StockServices.user.symbols = symbols
    }
}
