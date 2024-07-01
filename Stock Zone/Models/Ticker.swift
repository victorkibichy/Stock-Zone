//
//  Price.swift
//  Stock Zone
//
//  Created by  Bouncy Baby on 6/28/24.
//

import Foundation

struct Ticker: Codable {
    let ticker: String
    let name: String
    let type: String?
}

struct TickerListResponse: Codable {
    let results: [Ticker]
}

