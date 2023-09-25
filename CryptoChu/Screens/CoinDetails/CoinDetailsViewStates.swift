//
//  
//  CoinDetailsViewStates.swift
//  CryptoChu
//
//  Created by Barış Şaraldı on 23.09.2023.
//
//
import Foundation

// MARK: - CoinDetailsStates
enum CoinDetailsStates: ViewStateProtocol {
    case idle
    case loading
    case finished
    case error(error: String)
}
