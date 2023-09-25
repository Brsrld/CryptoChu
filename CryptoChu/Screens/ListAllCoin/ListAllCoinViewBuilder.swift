//
//  
//  ListAllCoinViewBuilder.swift
//  CryptoChu
//
//  Created by Barış Şaraldı on 21.09.2023.
//
//
import Foundation
import UIKit

// MARK: - ListAllCoinBuilder
struct ListAllCoinBuilder {
    static func build(coordinator: Coordinator) -> UIViewController {
        let service: ListAllCoinServiceable = ListAllCoinService()
        let viewModel: ListAllCoinViewModelProtocol = ListAllCoinViewModel(service: service)
        let viewController = ListAllCoinViewController(coordinator: coordinator,
                                                       viewModel: viewModel)
        
        return viewController
    }
}
