//
//  BaseViewState.swift
//  CryptoChu
//
//  Created by Barış Şaraldı on 24.09.2023.
//

import Foundation
// MARK: - ViewStateProtocol
protocol ViewStateProtocol {
    static var idle: Self { get }
}

// MARK: - DefaultViewState
enum DefaultViewState: ViewStateProtocol {
    case idle
}
