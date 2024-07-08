//
//  StockSnapshot.swift
//  Stock Zone
//
//  Created by  Bouncy Baby on 7/1/24.
//

import Foundation

struct StockSnapshotResponse: Codable {
    struct DayData: Codable {
        let c: Double // Closing price
        let h: Double // High price
        let l: Double // Low price
        let o: Double // Opening price
        let v: Int // Volume
        let vw: Double // Volume-weighted average price
    }
    
    let results: [DayData]
}

    struct LastQuoteData: Codable {
        let P: Double
        let S: Int
        let p: Double
        let s: Int
        let t: Int64
    }


    struct MinData: Codable {
        let av: Int
        let c: Double
        let h: Double
        let l: Double
        let n: Int
        let o: Double
        let t: Int64
        let v: Int
        let vw: Double
    }


   

