//
//  SmartStocksApp.swift
//  SmartStocks
//
//  Created by Tibor Felföldy on 2023-05-01.
//

import SwiftUI

@main
struct SmartStocksApp: App {
    @StateObject private var searchController = SearchController()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                WatchlistView(searchController: searchController, model: WatchlistViewModel())
                    .searchable(text: $searchController.query)
            }
        }
    }
}
