//
//  StockDetailsView.swift
//  SmartStocks
//
//  Created by Tibor Felföldy on 2023-05-02.
//

import SwiftUI

struct StockDetailsView: View {
    @StateObject var viewModel: StockDetailsViewModel
    
    var body: some View {
        Form {
            Section {
                HStack {
                    VStack(alignment: .leading) {
                        Text(viewModel.symbol)
                            .font(.headline)
                        Text("Technology")
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    AsyncImage(url: viewModel.logoUrl) { image in
                        image
                    } placeholder: {
                        Image(systemName: "apple.logo")
                    }
                }
                
                Text("161.95 $")
                    .font(.headline)
            }
        }
        .navigationTitle("Apple Inc.")
        .task {
            do {
                try await viewModel.loadCompanyDetails()
            } catch {
                print(error)
            }
        }
    }
}

struct StockDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            StockDetailsView(viewModel: StockDetailsViewModel(symbol: "AAPL", stocksService: PreviewStocksRepository()))
        }
    }
}
