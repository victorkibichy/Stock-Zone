//
//  Price.swift
//  Stock Zone
//
//  Created by  Bouncy Baby on 6/28/24.
//

import Foundation

struct TickerListResponse: Codable {
    let results: [Ticker]
}

// Ticker structure
struct Ticker: Codable {
    let ticker: String
}
