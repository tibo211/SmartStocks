//
//  ContentView.swift
//  SmartStocks
//
//  Created by Tibor Felföldy on 2023-05-01.
//

import SwiftUI
import StockServices

struct ContentView: View {
    var body: some View {
        VStack {
            Button("Subscribe to AAPL") {
                Task {
                    do {
                        try await StockServices.repository.subscribe(symbol: "AAPL")
                    } catch {
                        print(error)
                    }
                }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
