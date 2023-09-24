//
//  
//  ListAllCoinViewStates.swift
//  CryptoChu
//
//  Created by Barış Şaraldı on 21.09.2023.
//
//
import Foundation

enum ListAllCoinStates: ViewStateProtocol {
    case idle
    case loading
    case finished
    case error(error: String)
    case empty
}
