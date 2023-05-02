//
//  StockListModel.swift
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

final class StockListModel: ObservableObject {
    @Published var items = [String: StockItem]()
    
    let symbols = ["AAPL"]
    private let stocksService = ServiceProvider.stocksService
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        stocksService.priceUpdatePublisher.sink { [unowned self] updates in
            for (symbol, price) in updates {
                items[symbol]?.price = price
            }
        }
        .store(in: &subscriptions)
    }

    func loadQuotes() async throws {
        let quotes = try await withThrowingTaskGroup(of: QuoteResult.self) { group in
            for symbol in symbols {
                group.addTask { [self] in
                    try await stocksService.quote(symbol: symbol)
                }
            }
            
            var quotes = [QuoteResult]()
            quotes.reserveCapacity(symbols.count)
            for try await quote in group {
                quotes.append(quote)
            }
            return quotes
        }
        
        let items = zip(symbols, quotes)
            .map { symbol, quote in
                StockItem(symbol: symbol,
                          price: quote.currentPrice,
                          closePrice: quote.previousClosePrice)
            }

        try await stocksService.subscribe(symbols: Set(symbols))

        DispatchQueue.main.async {
            self.items = Dictionary(grouping: items, by: \.symbol)
                .compactMapValues(\.last)
        }
    }
}
