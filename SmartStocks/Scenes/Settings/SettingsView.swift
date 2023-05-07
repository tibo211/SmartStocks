//
//  SettingsView.swift
//  SmartStocks
//
//  Created by Tibor Felföldy on 2023-05-07.
//

import SwiftUI
import StockServices

struct SettingsView: View {
    @State private var finnhubKey = StockServices.user.finnhubAPIKey
    
    var body: some View {
        Form {
            Section("API keys") {
                VStack(alignment: .leading) {
                    Text("Finnhub")
                    TextField("API key", text: $finnhubKey)
                }

                Button("Save") {
                    StockServices.user.finnhubAPIKey = finnhubKey
                }
            }
        }
        .padding()
        .navigationTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
