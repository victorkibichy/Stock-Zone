//
//  NetworkManager.swift
//  Stock Zone
//
//  Created by  Bouncy Baby on 6/28/24.
//

import Foundation

// Define a custom error type for network errors
enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingError(Error)
}

class NetworkManager {
    
    private let apiKey = "2VbURjjrrKQG5F1hgNc4xm85eogWSFvY"
    
    // Base URL for Polygon.io
    private let baseURL = "https://api.polygon.io"
    
    // Fetch all tickers
    func fetchAllTickers(completion: @escaping (Result<[String], NetworkError>) -> Void) {
        // Endpoint for fetching all tickers
        let urlString = "\(baseURL)/v3/reference/tickers?active=true&apiKey=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        // Create a data task
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidResponse))
                return
            }
            
            do {
                // Decode the JSON response into TickerList
                let tickerResponse = try JSONDecoder().decode(TickerListResponse.self, from: data)
                
                // Extract the ticker symbols
                let tickers = tickerResponse.results.map { $0.ticker }
                
                // Return the ticker symbols
                completion(.success(tickers))
                
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        
        // Start the data task
        task.resume()
    }
}

// Models for the JSON response

// Main response structure
struct TickerListResponse: Codable {
    let results: [Ticker]
}

// Ticker structure
struct Ticker: Codable {
    let ticker: String
}
