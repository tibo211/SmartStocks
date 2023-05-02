//
//  StockDetailsView.swift
//  SmartStocks
//
//  Created by Tibor Felföldy on 2023-05-02.
//

import SwiftUI
import StockServices

struct StockDetailsView: View {
    @StateObject var viewModel: StockDetailsViewModel
    
    var body: some View {
        Form {
            Section {
                HStack {
                    VStack(alignment: .leading) {
                        Text(viewModel.symbol)
                            .font(.headline)
                        Text(viewModel.company?.industry ?? "unknown")
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    // TODO: Workaround for getting svg instead of png.
                    Image(systemName: "apple.logo")
                }
                
                Text(viewModel.price.currencyString())
                    .font(.headline)
            }
        }
        .navigationTitle(viewModel.company?.name ?? viewModel.symbol)
        .skeletonPlaceholder(viewModel.company == nil)
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
            StockDetailsView(viewModel: StockDetailsViewModel(symbol: "AAPL", price: 169.77, stocksService: PreviewStocksRepository()))
        }
    }
}
