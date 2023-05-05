//
//  CompanyDetailsViewModel.swift
//  SmartStocks
//
//  Created by Tibor Felföldy on 2023-05-02.
//

import Foundation
import StockServices

final class CompanyDetailsViewModel: ObservableObject {
    let symbol: String
    @Published private(set) var price: Double
    @Published private(set) var company: CompanyProfileResult?
    
    var logoUrl: URL? {
        guard let link = company?.logo else {
            return nil
        }
        return URL(string: link)
    }
    
    init(symbol: String, price: Double) {
        self.symbol = symbol
        self.price = price
    }
    
    func loadCompanyDetails() async throws {
        let companyProfile = try await ServiceProvider.stocksService
            .companyProfile(symbol: symbol)

        DispatchQueue.main.async {
            self.company = companyProfile
        }
    }
    
    func priceUpdates(_ updates: [String: Double]) {
        if let newPrice = updates[symbol] {
            price = newPrice
        }
    }
}
