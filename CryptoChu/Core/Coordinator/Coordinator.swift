//
//  Coordinator.swift
//  CryptoChu
//
//  Created by Barış Şaraldı on 21.09.2023.
//

import Foundation
import UIKit

// MARK: Coordinator
final class Coordinator: CoordinatorProtocol {
    // MARK: Properties
    var parentCoordinator: CoordinatorProtocol?
    var children: [CoordinatorProtocol] = []
    var navigationController: UINavigationController?
    
    // MARK: Functions
    func start() {
        let vc = ListAllCoinBuilder.build(coordinator: self)
        navigationController?.setViewControllers([vc],
                                                 animated: true)
    }

    func eventOccurred(with viewController: UIViewController) {
        navigationController?.pushViewController(viewController,
                                                 animated: true)
    }
}

