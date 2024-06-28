//
//  Stock.swift
//  Stock Zone
//
//  Created by  Bouncy Baby on 6/28/24.
//

import Foundation

struct StockPrice: Codable {
    let close: Double
    let high: Double
    let low: Double
    let numberOfTrades: Int
    let open: Double
    let timestamp: Int64  // Represented as Unix timestamp
    let volume: Int
    let volumeWeightedAverage: Double

    enum CodingKeys: String, CodingKey {
        case close = "c"
        case high = "h"
        case low = "l"
        case numberOfTrades = "n"
        case open = "o"
        case timestamp = "t"
        case volume = "v"
        case volumeWeightedAverage = "vw"
    }
}

// MARK: - StockPriceResponse Struct
struct StockPriceResponse: Codable {
    let adjusted: Bool
    let nextUrl: String?
    let queryCount: Int
    let requestId: String
    let results: [StockPrice]
    let resultsCount: Int
    let status: String
    let ticker: String

    enum CodingKeys: String, CodingKey {
        case adjusted
        case nextUrl = "next_url"
        case queryCount = "queryCount"
        case requestId = "request_id"
        case results
        case resultsCount = "resultsCount"
        case status
        case ticker
    }
}
