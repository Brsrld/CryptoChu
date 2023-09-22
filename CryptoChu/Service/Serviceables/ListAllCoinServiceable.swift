//
//  ListAllCoinServiceable.swift
//  CryptoChu
//
//  Created by Barış Şaraldı on 22.09.2023.
//

import Foundation

protocol ListAllCoinServiceable {
    func fetchAllCoinList() async -> Result<MarketInfoModel, RequestError>
}

struct ListAllCoinService: HTTPClient, ListAllCoinServiceable {
    func fetchAllCoinList() async -> Result<MarketInfoModel, RequestError> {
        return await sendRequest(endpoint: ListAllMarketInfo(), responseModel: MarketInfoModel.self)
    }
}
