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
    var isFavorite: String { get }
    func serviceInit()
}

// MARK: - CoinDetailsViewModel
final class CoinDetailsViewModel: BaseViewModel<CoinDetailsStates> {
    // MARK: - Properties
    private let service: CoinDetailsServiceable
    var marketCode: String
    var isFavorite: String
    var coinDetails: TickersInfoModel?
    
    // MARK: - Functions
    init(marketCode: String,
         isFavorite: String,
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

// MARK: - CoinDetailsViewModelProtocol
extension CoinDetailsViewModel : CoinDetailsViewModelProtocol {
    var statePublisher: Published<CoinDetailsStates>.Publisher {
        $states
    }
}
