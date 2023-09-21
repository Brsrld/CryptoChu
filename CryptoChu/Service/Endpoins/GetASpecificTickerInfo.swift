//
//  GetASpecificTickerInfo.swift
//  CryptoChu
//
//  Created by Barış Şaraldı on 21.09.2023.
//

import Foundation

struct GetASpecificTickerInfo: Endpoint {
    
    var marketCode: String
    
    var path: String {
        return "/api/v1/ticker/\(marketCode)/"
    }
    
    var method: RequestMethod {
        return .get
    }
}
