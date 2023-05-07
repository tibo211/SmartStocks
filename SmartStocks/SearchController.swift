//
//  SearchController.swift
//  SmartStocks
//
//  Created by Tibor Felföldy on 2023-05-03.
//

import Foundation
import Combine
import StockServices

final class SearchController: ObservableObject {
    @Published var query = ""
    @Published private(set) var searchResults = [Symbol]()
    
    init() {
        $query
            .filter { !$0.isEmpty }
            .debounce(for: 0.5, scheduler: DispatchQueue.global())
            .removeDuplicates()
            .map { query in
                Future<[Symbol], Never> { promise in
                    Task {
                        let results = try await ServiceProvider.stocksService
                            .symbolLookup(query: query)
                        let filterred = results.filter { !$0.symbol.contains(".") }
                        promise(.success(filterred))
                    }
                }
            }
            .switchToLatest()
            .receive(on: RunLoop.main)
            .assign(to: &$searchResults)
        
        $query.filter(\.isEmpty)
            .map { _ in [] }
            .assign(to: &$searchResults)
    }
}
