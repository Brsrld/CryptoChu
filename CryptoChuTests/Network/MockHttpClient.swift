//
//  MockHttpClient.swift
//  CryptoChuTests
//
//  Created by Barış Şaraldı on 24.09.2023.
//

import Foundation
@testable import CryptoChu

final class MockHttpClient: ListAllCoinServiceable, CoinDetailsServiceable, Mockable {
    let filename: String
    
    init(filename: String) {
        self.filename = filename
    }
    
    func fetchAllCoinList() async -> Result<CryptoChu.MarketInfoModel, CryptoChu.RequestError> {
        return await loadJson(filename: filename,
                              extensionType: .json,
                              responseModel: CryptoChu.MarketInfoModel.self)
    }
    
    func fetchCoinDetails(marketCode: String) async -> Result<CryptoChu.TickersInfoModel, CryptoChu.RequestError> {
        return await loadJson(filename: filename,
                              extensionType: .json,
                              responseModel: CryptoChu.TickersInfoModel.self)
    }
}

