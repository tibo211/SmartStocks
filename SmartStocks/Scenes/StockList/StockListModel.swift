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
    @Published var items = [StockItem]()
    
    let symbols = ["AAPL"]
    private let stocksService: StocksRepository
    
    init(stocksService: StocksRepository = StockServices.repository) {
        self.stocksService = stocksService
        stocksService.priceUpdatePublisher
            .catch { error in
                print(error)
                return Just([StockPrice]())
            }
            .combineLatest($items) { updates, items in
                var updatedItems = items
                
                for update in updates {
                    let i = items.firstIndex(where: { $0.symbol == update.symbol })
                    if let i {
                        updatedItems[i].price = update.price
                    }
                }
                
                return updatedItems
            }
            // TODO: When values received that are not the in the latest they will not be updated.
            .throttle(for: .seconds(1), scheduler: RunLoop.main, latest: true)
            .receive(on: RunLoop.main)
            .assign(to: &$items)
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

        for symbol in symbols {
            try await stocksService.subscribe(symbol: symbol)
        }

        DispatchQueue.main.async {
            self.items = items
        }
    }
}
