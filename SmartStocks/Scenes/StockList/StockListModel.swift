//
//  StockListModel.swift
//  SmartStocks
//
//  Created by Tibor Felföldy on 2023-05-02.
//

import Foundation
import StockServices

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
    }
    
    func loadQuotes() async throws {
        let quotes = try await withThrowingTaskGroup(of: QuoteResult.self) { group in
            for symbol in symbols {
                group.addTask {
                    try await StockServices.repository.quote(symbol: symbol)
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
        
        DispatchQueue.main.async {
            self.items = items
        }
    }
}
