//
//  
//  CoinDetailsViewModel.swift
//  CryptoChu
//
//  Created by Barış Şaraldı on 23.09.2023.
//
//
import Foundation
import Combine

// MARK: - CoinDetailsViewModelProtocol
protocol CoinDetailsViewModelProtocol {
    var statePublisher: Published<CoinDetailsStates>.Publisher { get }
    var coinDetails: TickersInfoModel? { get }
    var marketCode: String { get }
    var isFavorite: Bool { get }
    func serviceInit()
}

final class CoinDetailsViewModel: BaseViewModel<CoinDetailsStates> {
    private let service: CoinDetailsServiceable
    var marketCode: String
    var isFavorite: Bool
    var coinDetails: TickersInfoModel?
    
    init(marketCode: String,
         isFavorite: Bool,
         service: CoinDetailsServiceable) {
        self.marketCode = marketCode
        self.isFavorite = isFavorite
        self.service = service
    }
    
    func serviceInit() {
        changeState(.loading)
        Task { [weak self] in
            guard let self = self else { return }
            let result = await self.service.fetchCoinDetails(marketCode: marketCode)
            self.changeState(.finished)
            switch result {
            case .success(let success):
                self.coinDetails = success
            case .failure(let failure):
                self.changeState(.error(error: failure.customMessage))
            }
        }
    }
}

extension CoinDetailsViewModel : CoinDetailsViewModelProtocol {
    var statePublisher: Published<CoinDetailsStates>.Publisher {
        $states
    }
}
