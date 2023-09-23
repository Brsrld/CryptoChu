//
//  MarketInfoModel.swift
//  CryptoChu
//
//  Created by Barış Şaraldı on 21.09.2023.
//

import Foundation

// MARK: - MarketInfoModel
struct MarketInfoModel: Codable {
    let status: String?
    var data: MarketData?
}

// MARK: - MarketData
struct MarketData: Codable {
    var markets: [Market]?
}

// MARK: - Market
struct Market: Codable {
    let marketCode: String?
    let urlSymbol: String?
    let baseCurrency: String?
    let counterCurrency: String?
    let minimumOrderAmount: String?
    let maximumOrderAmount: String?
    let baseCurrencyDecimal: Int?
    let counterCurrencyDecimal: Int?
    let presentationDecimal: Int?
    let resellMarket: Bool?
    let minMultiplier: String?
    let maxMultiplier: String?
    let listDate: Int?
    let baseCurrencyName: String?
    let counterCurrencyName: String?
    let triggerOrder: TriggerOrder?
    var isFavorite: Bool? = false
    
    enum CodingKeys: String, CodingKey {
        case marketCode = "market_code"
        case urlSymbol = "url_symbol"
        case baseCurrency = "base_currency"
        case counterCurrency = "counter_currency"
        case minimumOrderAmount = "minimum_order_amount"
        case maximumOrderAmount = "maximum_order_amount"
        case baseCurrencyDecimal = "base_currency_decimal"
        case counterCurrencyDecimal = "counter_currency_decimal"
        case presentationDecimal = "presentation_decimal"
        case resellMarket = "resell_market"
        case minMultiplier = "min_multiplier"
        case maxMultiplier = "max_multiplier"
        case listDate = "list_date"
        case baseCurrencyName = "base_currency_name"
        case counterCurrencyName = "counter_currency_name"
        case triggerOrder = "trigger_order"
    }
}

// MARK: - TriggerOrder
struct TriggerOrder: Codable {
    let l: Bool?
    let m: Bool?
    
    enum CodingKeys: String, CodingKey{
        case l = "L"
        case m = "M"
    }
}


