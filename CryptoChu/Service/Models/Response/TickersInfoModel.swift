//
//  TickersInfoModel.swift
//  CryptoChu
//
//  Created by Barış Şaraldı on 21.09.2023.
//

import Foundation

// MARK: - TickersInfoModel
struct TickersInfoModel: Codable {
    let status: String?
    let data: TickerData?
}

// MARK: - TickerData
struct TickerData: Codable {
    let ticker: Ticker?
}

// MARK: - Ticker
struct Ticker: Codable {
    let market: TickerMarket?
    let bid: String?
    let ask: String?
    let lastPrice: String?
    let lastSize: String?
    let volume24H: String?
    let change24H: String?
    let low24H: String?
    let high24H: String?
    let avg24H: String?
    let timestamp: String?
    
    enum CodingKeys: String, CodingKey {
        case market = "market"
        case bid = "bid"
        case ask = "ask"
        case lastPrice = "last_price"
        case lastSize = "last_size"
        case volume24H = "volume_24h"
        case change24H = "change_24h"
        case low24H = "low_24h"
        case high24H = "high_24h"
        case avg24H = "avg_24h"
        case timestamp = "timestamp"
    }
}

// MARK: - Market
struct TickerMarket: Codable {
    let marketCode: String?
    let baseCurrencyCode: String?
    let counterCurrencyCode: String?
    
    enum CodingKeys: String, CodingKey {
        case marketCode = "market_code"
        case baseCurrencyCode = "base_currency_code"
        case counterCurrencyCode = "counter_currency_code"
    }
}
