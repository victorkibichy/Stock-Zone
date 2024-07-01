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
    
    // Fetching all tickers using RxSwift Observable
    func fetchAllTickers() -> Observable<[Ticker]> {
        return Observable.create { [self] observer in
            let urlString = "\(baseURL)/v3/reference/tickers?active=true&apiKey=\(apiKey)"
            
            guard let url = URL(string: urlString) else {
                observer.onError(NetworkError.invalidURL)
                return Disposables.create()
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    observer.onError(NetworkError.requestFailed(error))
                    return
                }
                
                guard let data = data else {
                    observer.onError(NetworkError.invalidResponse)
                    return
                }
                
                do {
                    let tickerResponse = try JSONDecoder().decode(TickerListResponse.self, from: data)
                    let tickers = tickerResponse.results
                    observer.onNext(tickers)
                    observer.onCompleted()
                } catch {
                    observer.onError(NetworkError.decodingError(error))
                }
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
