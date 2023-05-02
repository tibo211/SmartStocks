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
    @Published private(set) var companyProfile: CompanyProfileResult?
    
    var logoUrl: URL? {
        guard let link = companyProfile?.logo else {
            return nil
        }
        return URL(string: link)
    }
    
    private let stocksService: StocksRepository
    
    init(symbol: String, stocksService: StocksRepository = StockServices.repository) {
        self.symbol = symbol
        self.stocksService = stocksService
    }
    
    func loadCompanyDetails() async throws {
        let companyProfile = try await stocksService.companyProfile(symbol: symbol)
        
        DispatchQueue.main.async {
            self.companyProfile = companyProfile
        }
    }
}
