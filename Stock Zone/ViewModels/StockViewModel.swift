//
//  StockViewMode.swift
//  Stock Zone
//
//  Created by  Bouncy Baby on 6/28/24.
//

import Foundation

class StockViewModel {

    // MARK: - Properties
    private let networkManager = NetworkManager()
    private(set) var tickers: [String] = [] {
        didSet {
            self.updateUI?()
        }
    }
    
    var onError: ((String) -> Void)?
    var updateUI: (() -> Void)?
    
    // MARK: - Fetch All Tickers
    func fetchAllTickers() {
        networkManager.fetchAllTickers { [weak self] result in
            switch result {
            case .success(let tickerData):
                // Assuming tickerData is an array of strings representing tickers
                self?.tickers = tickerData
            case .failure(let error):
                self?.onError?("Failed to fetch tickers: \(error.localizedDescription)")
            }
        }
    }
}
