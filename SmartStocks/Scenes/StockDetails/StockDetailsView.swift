//
//  StockDetailsView.swift
//  SmartStocks
//
//  Created by Tibor Felföldy on 2023-05-02.
//

import SwiftUI

struct StockDetailsView: View {
    var body: some View {
        Form {
            Section {
                HStack {
                    VStack(alignment: .leading) {
                        Text("AAPL")
                            .font(.headline)
                        Text("Technology")
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "apple.logo")
                }
                
                Text("161.95 $")
                    .font(.headline)
            }
        }
        .navigationTitle("Apple Inc.")
    }
}

struct StockDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            StockDetailsView()
        }
    }
}
