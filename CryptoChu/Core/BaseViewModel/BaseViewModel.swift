//
//  BaseViewModel.swift
//  CryptoChu
//
//  Created by Barış Şaraldı on 24.09.2023.
//

import Foundation
// MARK: - BaseViewModel
class BaseViewModel<E: ViewStateProtocol> {
    @Published var states: E = .idle
    
    func changeState(_ state: E) {
        DispatchQueue.main.async { [weak self] in
            if self?.states == state {
                debugPrint("Already \(state)")
                return
            }
            self?.states = state
            debugPrint("State changed to \(state)")
        }
    }
}
