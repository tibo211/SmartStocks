//
//  StockDetailsViewModel.swift
//  SmartStocks
//
//  Created by Tibor Felföldy on 2023-05-02.
//

import Foundation
import StockServices

final class StockDetailsViewModel: ObservableObject {
    let symbol: String
    let price: Double
    @Published private(set) var company: CompanyProfileResult?
    
    var logoUrl: URL? {
        guard let link = company?.logo else {
            return nil
        }
        return URL(string: link)
    }
    
    private let stocksService: StocksRepository
    
    init(symbol: String, price: Double, stocksService: StocksRepository = StockServices.repository) {
        self.symbol = symbol
        self.price = price
        self.stocksService = stocksService
    }
    
    func loadCompanyDetails() async throws {
        let companyProfile = try await stocksService.companyProfile(symbol: symbol)
        
        DispatchQueue.main.async {
            self.company = companyProfile
        }
    }
}
