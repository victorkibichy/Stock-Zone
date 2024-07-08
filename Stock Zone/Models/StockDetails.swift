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
    let timestamp: Int64  
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

struct DayDetails: Codable {
    let close: Double
    let high: Double
    let low: Double
    let open: Double
    let volume: Int
    let volumeWeightedAverage: Double

    enum CodingKeys: String, CodingKey {
        case close = "c"
        case high = "h"
        case low = "l"
        case open = "o"
        case volume = "v"
        case volumeWeightedAverage = "vw"
    }
}

struct StockDetail {
    let high: Double
    let low: Double
    let open: Double
    let close: Double
    let volume: Int
    
    init(dayDetails: DayDetails) {
        self.high = dayDetails.high
        self.low = dayDetails.low
        self.open = dayDetails.open
        self.close = dayDetails.close
        self.volume = Int(dayDetails.volumeWeightedAverage)
    }
}
