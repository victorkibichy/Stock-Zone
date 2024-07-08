//
//  NetworkManager.swift
//  Stock Zone
//
//  Created by Bouncy Baby on 6/28/24.
//

import Foundation
import RxSwift

class NetworkManager {
    
    private let apiKey = "2VbURjjrrKQG5F1hgNc4xm85eogWSFvY"
    private let baseURL = "https://api.polygon.io"
    
    // Fetching tickers with pagination
    func fetchTickers(limit: Int, offset: Int) -> Observable<[Ticker]> {
        let urlString = "\(baseURL)/v3/reference/tickers?active=true&apiKey=\(apiKey)&limit=\(limit)&offset=\(offset)"
        
        guard let url = URL(string: urlString) else {
            return Observable.error(NetworkError.invalidURL)
        }
        
        return URLSession.shared.rx.data(request: URLRequest(url: url))
            .map { data in
                do {
                    let tickerResponse = try JSONDecoder().decode(TickerListResponse.self, from: data)
                    return tickerResponse.results
                } catch {
                    throw NetworkError.decodingError(error)
                }
            }
    }
    
    // Searching tickers based on query
    func searchTickers(query: String) -> Observable<[Ticker]> {
        let urlString = "\(baseURL)/v3/reference/tickers?search=\(query)&active=true&apiKey=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            return Observable.error(NetworkError.invalidURL)
        }
        
        return URLSession.shared.rx.data(request: URLRequest(url: url))
            .map { data in
                do {
                    let tickerResponse = try JSONDecoder().decode(TickerListResponse.self, from: data)
                    return tickerResponse.results
                } catch {
                    throw NetworkError.decodingError(error)
                }
            }
    }
    
    static func fetchStockDetails(for ticker: String) -> Observable<StockSnapshotResponse.DayData?> {
        let baseURL = "https://api.polygon.io/v2/aggs/ticker/"
        let apiKey = "2VbURjjrrKQG5F1hgNc4xm85eogWSFvY"
        let urlString = "\(baseURL)\(ticker)/range/1/day/2023-01-09/2023-02-10?adjusted=true&sort=asc&apiKey=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            return Observable.error(NetworkError.invalidURL)
        }
        
        let request = URLRequest(url: url)
        
        return URLSession.shared.rx.data(request: request)
            .map { data in
                do {
                    let response = try JSONDecoder().decode(StockSnapshotResponse.self, from: data)
                    print("Network Response: \(response)")
                    return response.results.first // Assuming we take the first day's data for display
                } catch {
                    print("Decoding error: \(error)")
                    throw NetworkError.decodingError(error)
                }
            }
        }
    }

// Helper method to format date in required API format
        private func formatDate() -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.string(from: Date())
        }

