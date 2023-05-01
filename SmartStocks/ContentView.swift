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
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
