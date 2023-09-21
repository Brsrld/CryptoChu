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

struct ListAllCoinBuilder {
    static func build(coordinator: Coordinator) -> UIViewController {
        
        let viewModel = ListAllCoinViewModel()
        let viewController = ListAllCoinViewController(coordinator: coordinator, viewModel: viewModel)
        
        return viewController
    }
}
