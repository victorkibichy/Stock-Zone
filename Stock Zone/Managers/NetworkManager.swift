//
//  NetworkManager.swift
//  Stock Zone
//
//  Created by Bouncy Baby on 6/28/24.
//

import Foundation
import RxSwift

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingError(Error)
}

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
}
