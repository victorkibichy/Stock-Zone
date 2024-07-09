//
//  Error Types.swift
//  Stock Zone
//
//  Created by  Bouncy Baby on 7/1/24.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingError(Error)
    case noData

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL provided was invalid."
        case .requestFailed(let error):
            return "The network request failed with error: \(error.localizedDescription)"
        case .invalidResponse:
            return "The response from the server was invalid."
        case .decodingError(let error):
            return "There was an error decoding the response: \(error.localizedDescription)"
        case .noData:
            return "The request returned no data."
        }
    }
}

extension NetworkError {
    func log() {
        switch self {
        case .invalidURL:
            print("Error: \(self.localizedDescription)")
        case .requestFailed(let error):
            print("Error: \(self.localizedDescription). Original Error: \(error)")
        case .invalidResponse:
            print("Error: \(self.localizedDescription)")
        case .decodingError(let error):
            print("Error: \(self.localizedDescription). Decoding Error Details: \(error)")
        case .noData:
            print("Error: \(self.localizedDescription)")
        }
    }
}
