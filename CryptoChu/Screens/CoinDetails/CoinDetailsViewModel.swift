//
//  
//  CoinDetailsViewModel.swift
//  CryptoChu
//
//  Created by Barış Şaraldı on 23.09.2023.
//
//
import Foundation

final class CoinDetailsViewModel: ViewModel<CoinDetailsStates> {
    private let service: CoinDetailsServiceable
    let coinInfo: Market
    var coinDetails: TickersInfoModel?
    
    init(coinInfo: Market,
         service: CoinDetailsServiceable) {
        self.coinInfo = coinInfo
        self.service = service
    }
    
    func serviceInit() {
        guard let marketCode =  coinInfo.marketCode else { return }
        changeState(newState: .loading)
        Task { [weak self] in
            guard let self = self else { return }
            let result = await self.service.fetchCoinDetails(marketCode: marketCode)
            self.changeState(newState: .finished)
            switch result {
            case .success(let success):
                self.coinDetails = success
            case .failure(let failure):
                self.changeState(newState: .error(error: failure.customMessage))
            }
        }
    }
}
