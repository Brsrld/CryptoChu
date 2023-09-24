//
//  
//  CoinDetailsViewBuilder.swift
//  CryptoChu
//
//  Created by Barış Şaraldı on 23.09.2023.
//
//
import Foundation
import UIKit

struct CoinDetailsBuilder {
    static func build(coordinator: Coordinator, marketCode: String, isFavorite: Bool) -> UIViewController {
        let service: CoinDetailsServiceable = CoinDetailsService()
        let viewModel: CoinDetailsViewModelProtocol = CoinDetailsViewModel(marketCode: marketCode, isFavorite: isFavorite, service: service)
        let viewController = CoinDetailsViewController(coordinator: coordinator, viewModel: viewModel)
        
        return viewController
    }
}
