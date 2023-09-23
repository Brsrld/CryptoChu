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
    private var serviceData: MarketInfoModel?
    
    init(service: ListAllCoinServiceable) {
        self.service = service
    }
    
    func isFavoriteControl(index: Int) {
        coinList?.data?.markets?[index].isFavorite?.toggle()
        UserDefaults.standard.set(coinList.encode(), forKey: "coinList")
    }
    
    func fillCoinData() {
        serviceInit()
        readData()
        serviceData = coinList
    }
    
    func searchCoins(text: String) {
        guard let data = self.serviceData?.data?.markets else { return }
        var searchedData: [Market] = []
        
        searchedData = data.filter({
            guard let first = $0.baseCurrency?.lowercased().contains(text.lowercased()),
                  let second = $0.counterCurrency?.lowercased().contains(text.lowercased()) else { return false }
            return first || second })
        
        coinList?.data?.markets = text != "" ? searchedData : data
    }
    
    private func readData() {
        guard let favoriteData = UserDefaults.standard.object(forKey: "coinList") as? Data,
              let favoriteCoins = try? JSONDecoder().decode(MarketInfoModel?.self, from: favoriteData) else { return }
        self.coinList = favoriteCoins
    }
    
    private func serviceInit() {
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
