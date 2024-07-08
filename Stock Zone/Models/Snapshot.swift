//
//  Snapshot.swift
//  Stock Zone
//
//  Created by  Bouncy Baby on 7/2/24.
//

import Foundation


struct SnapshotResponse: Codable {
    let ticker: StockPrice?  
}

    
    struct DayData: Codable {
        let close: Double?
        let high: Double?
        let low: Double?
        let open: Double?
        let volume: Int64?
    }
    
    struct LastTradeData: Codable {
        let price: Double?
        let size: Int64?
        let exchange: Int?
        let cond1: Int?
        let cond2: Int?
        let cond3: Int?
        let cond4: Int?
        let timestamp: Int64?
    }
    
    struct PrevDayData: Codable {
        let close: Double?
        let high: Double?
        let low: Double?
        let open: Double?
        let volume: Int64?
    }



struct TickerDetail: Codable {
    let day: DayDetails?
}


struct StockPriceResponse: Codable {
    let request_id: String
    let status: String
    let ticker: TickerDetails
}

struct TickerDetails: Codable {
    let day: DayDetails
    let lastQuote: LastQuoteDetails
    let lastTrade: LastTradeDetails
    let min: MinDetails
    let prevDay: PrevDayDetails
    let ticker: String
    let todaysChange: Double
    let todaysChangePerc: Double
    let updated: Int64
}



struct LastQuoteDetails: Codable {
    let P: Double // Bid price
    let S: Int    // Bid size
    let p: Double // Ask price
    let s: Int    // Ask size
    let t: Int64  // Timestamp
}

struct LastTradeDetails: Codable {
    let c: [Int]  // Conditions
    let i: String // ID
    let p: Double // Price
    let s: Int    // Size
    let t: Int64  // Timestamp
    let x: Int    // Exchange ID
}

struct MinDetails: Codable {
    let av: Int   // Average volume
    let c: Double // Close price
    let h: Double // High price
    let l: Double // Low price
    let n: Int    // Number of trades
    let o: Double // Open price
    let t: Int64  // Timestamp
    let v: Int    // Volume
    let vw: Double // Volume weighted average price
}

struct PrevDayDetails: Codable {
    let c: Double // Close price
    let h: Double // High price
    let l: Double // Low price
    let o: Double // Open price
    let v: Int    // Volume
    let vw: Double // Volume weighted average price
}





// This model represents the entire API response
struct StockDetailResponse: Codable {
    let status: String
    let tickers: [TickerDetail]
    
    struct TickerDetail: Codable {
        let day: DayDetails
        let lastQuote: QuoteDetails
        let lastTrade: TradeDetails
        let min: MinDetails
        let prevDay: PrevDayDetails
        let ticker: String
        let todaysChange: Double
        let todaysChangePerc: Double
        let updated: Int64
        
        struct QuoteDetails: Codable {
            let P: Double
            let S: Int
            let p: Double
            let s: Int
            let t: Int64
            
            enum CodingKeys: String, CodingKey {
                case P
                case S
                case p
                case s
                case t
            }
        }
        
        struct TradeDetails: Codable {
            let c: [Int]
            let i: String
            let p: Double
            let s: Int
            let t: Int64
            let x: Int
            
            enum CodingKeys: String, CodingKey {
                case c
                case i
                case p
                case s
                case t
                case x
            }
        }
        
        struct MinDetails: Codable {
            let av: Int
            let c: Double
            let h: Double
            let l: Double
            let n: Int
            let o: Double
            let t: Int64
            let v: Int
            let vw: Double
            
            enum CodingKeys: String, CodingKey {
                case av
                case c
                case h
                case l
                case n
                case o
                case t
                case v
                case vw
            }
        }
        
        struct PrevDayDetails: Codable {
            let c: Double
            let h: Double
            let l: Double
            let o: Double
            let v: Int
            let vw: Double
            
            enum CodingKeys: String, CodingKey {
                case c
                case h
                case l
                case o
                case v
                case vw
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case day
            case lastQuote
            case lastTrade
            case min
            case prevDay
            case ticker
            case todaysChange
            case todaysChangePerc
            case updated
        }
    }
}

