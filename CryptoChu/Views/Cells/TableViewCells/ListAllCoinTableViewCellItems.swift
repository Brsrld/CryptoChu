//
//  ListAllCoinTableViewCellItems.swift
//  CryptoChu
//
//  Created by Barış Şaraldı on 22.09.2023.
//

import Foundation
import UIKit

// MARK: - ListAllCoinTableViewCellOutputProtocol
protocol ListAllCoinTableViewCellOutputProtocol: NSObject {
    func onTapped(indexPath: Int?)
}

// MARK: - Items
struct ListAllCoinTableViewCellItems {
    let baseCurrency: String?
    let counterCurrency: String?
    let indexPath: Int?
    var buttonImage: String?
    weak var delegate: ListAllCoinTableViewCellOutputProtocol?
    
}
