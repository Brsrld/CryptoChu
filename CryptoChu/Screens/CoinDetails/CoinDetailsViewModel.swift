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
    var coinInfo: Market { get }
    func serviceInit()
}

final class CoinDetailsViewModel: BaseViewModel<CoinDetailsStates> {
    private let service: CoinDetailsServiceable
    var coinInfo: Market
    var coinDetails: TickersInfoModel?
    
    init(coinInfo: Market,
         service: CoinDetailsServiceable) {
        self.coinInfo = coinInfo
        self.service = service
    }
    
    func serviceInit() {
        guard let marketCode =  coinInfo.marketCode else { return }
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
