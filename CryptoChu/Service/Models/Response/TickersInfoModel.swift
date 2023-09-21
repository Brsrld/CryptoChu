//
//  TickersInfoModel.swift
//  CryptoChu
//
//  Created by Barış Şaraldı on 21.09.2023.
//

import Foundation

// MARK: - TickersInfoModel
struct TickersInfoModel {
    let status: String?
    let data: TickerData?
}

// MARK: - TickerData
struct TickerData {
    let ticker: Ticker?
}

// MARK: - Ticker
struct Ticker {
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
}

// MARK: - Market
struct TickerMarket {
    let marketCode: String?
    let baseCurrencyCode: String?
    let counterCurrencyCode: String?
}
