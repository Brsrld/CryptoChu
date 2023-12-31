//
//  CoinDetailsServiceable.swift
//  CryptoChu
//
//  Created by Barış Şaraldı on 23.09.2023.
//

import Foundation

// MARK: - CoinDetailsServiceable
protocol CoinDetailsServiceable {
    func fetchCoinDetails(marketCode: String) async -> Result<TickersInfoModel, RequestError>
}

// MARK: - CoinDetailsService
struct CoinDetailsService: HTTPClient, CoinDetailsServiceable {
    func fetchCoinDetails(marketCode: String) async -> Result<TickersInfoModel, RequestError> {
        return await sendRequest(endpoint: GetASpecificTickerInfo(marketCode: marketCode),
                                 responseModel: TickersInfoModel.self)
    }
}

