//
//  GetASpecificMarketInfo.swift
//  CryptoChu
//
//  Created by Barış Şaraldı on 21.09.2023.
//

import Foundation

struct GetASpecificMarketInfo: Endpoint {
    
    var marketCode: String
    
    var path: String {
        return "/api/v1/market_info/\(marketCode)/"
    }
    
    var method: RequestMethod {
        return .get
    }
}
