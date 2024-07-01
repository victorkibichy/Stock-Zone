//
//  Error Types.swift
//  Stock Zone
//
//  Created by  Bouncy Baby on 7/1/24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingError(Error)
}
