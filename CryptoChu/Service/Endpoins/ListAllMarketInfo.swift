//
//  ListAllMarketInfo.swift
//  CryptoChu
//
//  Created by Barış Şaraldı on 21.09.2023.
//

import Foundation

struct ListAllMarketInfo: Endpoint {
    var path: String {
        return "/api/v1/market_info/"
    }
    
    var method: RequestMethod {
        return .get
    }
}
