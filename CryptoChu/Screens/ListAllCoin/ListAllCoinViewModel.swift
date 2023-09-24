//
//  
//  ListAllCoinViewModel.swift
//  CryptoChu
//
//  Created by Barış Şaraldı on 21.09.2023.
//
//
import Foundation
import Combine

// MARK: - ListAllCoinViewModelProtocol
protocol ListAllCoinViewModelProtocol {
    var statePublisher: Published<ListAllCoinStates>.Publisher { get }
    var coinList: MarketInfoModel? { get set }
    func searchCoins(text: String)
    func isFavoriteControl(index: Int)
    func readData()
    func checkEmptyState()
    func serviceInit()
}

final class ListAllCoinViewModel: BaseViewModel<ListAllCoinStates> {
    
    private var service: ListAllCoinServiceable
    private var serviceData: MarketInfoModel?
    var coinList: MarketInfoModel?
    
    init(service: ListAllCoinServiceable) {
        self.service = service
    }
    
    func isFavoriteControl(index: Int) {
        coinList?.data?.markets?[index].isFavorite?.toggle()
        UserDefaults.standard.set(coinList.encode(), forKey: "coinList")
    }
    
    func searchCoins(text: String) {
        guard let data = self.serviceData?.data?.markets else { return }
        var searchedData: [Market] = []
        let condition = text.count > 2 && text != ""
        
        searchedData = data.filter({
            guard let first = $0.baseCurrency?.lowercased().contains(text.lowercased()),
                  let second = $0.counterCurrency?.lowercased().contains(text.lowercased()) else { return false }
            return first || second })
        
        coinList?.data?.markets = condition ? searchedData : data
        checkEmptyState()
    }
    
    func readData() {
        guard let favoriteData = UserDefaults.standard.object(forKey: "coinList") as? Data,
              let favoriteCoins = try? JSONDecoder().decode(MarketInfoModel?.self,
                                                            from: favoriteData) else { return }
        self.coinList = favoriteCoins
    }
    
    func checkEmptyState() {
        guard let coinlistStatus = self.coinList?.data?.markets?.isEmpty,
              let serviceDataStatus = self.serviceData?.data?.markets?.isEmpty else { return changeState(.empty)}
        
        if coinlistStatus || serviceDataStatus {
            changeState(.empty)
        } else {
            changeState(.finished)
        }
    }
    
    func serviceInit() {
        changeState(.loading)
        Task { [weak self] in
            guard let self = self else { return }
            let result = await self.service.fetchAllCoinList()
            self.changeState(.finished)
            switch result {
            case .success(let success):
                self.serviceData = success
                self.coinList = success
            case .failure(let failure):
                self.changeState(.error(error: failure.customMessage))
            }
        }
    }
}

extension ListAllCoinViewModel: ListAllCoinViewModelProtocol {
    var statePublisher: Published<ListAllCoinStates>.Publisher {
        $states
    }
}
