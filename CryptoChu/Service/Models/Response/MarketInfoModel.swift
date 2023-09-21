//
//  MarketInfoModel.swift
//  CryptoChu
//
//  Created by Barış Şaraldı on 21.09.2023.
//

import Foundation

// MARK: - MarketInfoModel
struct MarketInfoModel {
    let status: String?
    let data: MarketData?
}

// MARK: - MarketData
struct MarketData {
    let markets: [Market]?
}

// MARK: - Market
struct Market {
    let marketCode: String?
    let urlSymbol: String?
    let baseCurrency: String?
    let counterCurrency: String?
    let minimumOrderAmount: String?
    let baseCurrencyDecimal: Int?
    let counterCurrencyDecimal: Int?
}
