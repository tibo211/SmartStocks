//
//  CompanyDetailsView.swift
//  SmartStocks
//
//  Created by Tibor Felföldy on 2023-05-02.
//

import SwiftUI
import StockServices
import Charts

struct CompanyDetailsView: View {
    @StateObject var viewModel: CompanyDetailsViewModel
    
    var body: some View {
        Form {
            Section {
                HStack {
                    VStack(alignment: .leading) {
                        Text(viewModel.company?.name ?? viewModel.symbol)
                            .font(.headline)
                        Text(viewModel.company?.industry ?? "unknown")
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()

                    #if os(iOS)
                    CompanyImageView(url: viewModel.logoUrl)
                    #endif
                }
                
                HStack {
                    Text(viewModel.price.currencyString(currency: viewModel.company?.currency ?? ""))
                        .font(.headline)
                    
                    Spacer()
                    
                    Text(viewModel.company?.exchange ?? "")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                
                if let candles = viewModel.chartData {
                    Chart(candles, id: \.time) { candle in
                        LineMark(x: .value("date", candle.time),
                                 y: .value("price", candle.closePrice))
                    }
                    .chartYScale(domain: .automatic(includesZero: false))
                }
            }
        }
        #if os(macOS)
        .padding()
        #endif
        .setContentBackground()
        .navigationTitle(viewModel.symbol)
        .skeletonPlaceholder(viewModel.company == nil)
        .animation(.default, value: viewModel.company == nil)
        .animation(.default, value: viewModel.chartData == nil)
        .awaitAndCatch {
            try await viewModel.loadCompanyDetails()
            try await viewModel.loadChart()
        }
        .onReceive(ServiceProvider.stocksService.priceUpdatePublisher) { updates in
            viewModel.priceUpdates(updates)
        }
    }
}

struct StockDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CompanyDetailsView(viewModel: CompanyDetailsViewModel(symbol: "AAPL", price: 169.77))
        }
    }
}
