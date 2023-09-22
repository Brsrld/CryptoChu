//
//  Dictionary+Extension.swift
//  CryptoChu
//
//  Created by Barış Şaraldı on 22.09.2023.
//

import Foundation

extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}
