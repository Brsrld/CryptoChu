//
//  
//  ListAllCoinViewModel.swift
//  CryptoChu
//
//  Created by Barış Şaraldı on 21.09.2023.
//
//
import Foundation

final class ListAllCoinViewModel: ViewModel<ListAllCoinStates> {
    
    private var service: ListAllCoinServiceable
    private(set) var coinList: MarketInfoModel?
    
    init(service: ListAllCoinServiceable) {
        self.service = service
    }
    
    func isFavoriteControl(index: Int) {
        coinList?.data?.markets?[index].isFavorite?.toggle()
        UserDefaults.standard.set(coinList.encode(), forKey: "coinList")
    }
    
    func readData() {
        if let data = UserDefaults.standard.object(forKey: "coinList") as? Data,
           let coins = try? JSONDecoder().decode(MarketInfoModel?.self, from: data) {
            if coins.data?.markets?.count == coinList?.data?.markets?.count {
                coinList = coins
            }
        }
    }

    func serviceInit() {
        changeState(newState: .loading)
        Task { [weak self] in
            guard let self = self else { return }
            let result = await self.service.fetchAllCoinList()
            self.changeState(newState: .finished)
            switch result {
            case .success(let success):
                self.coinList = success
            case .failure(let failure):
                self.changeState(newState: .error(error: failure.customMessage))
            }
        }
    }
}
