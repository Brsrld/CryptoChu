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
    private var favoriteCoins: [Market] = []
    private var coinList: MarketInfoModel?
    var filteredCoinList: [Market] = []
    
    init(service: ListAllCoinServiceable) {
        self.service = service
    }
    
    private func readData() {
        if let data = UserDefaults.standard.object(forKey: "coinList") as? Data,
           let pets = try? JSONDecoder().decode([Market].self, from: data) {
            self.favoriteCoins = pets
        }
    }
    
    private func filterData() {
        let filteredData = coinList?.data?.markets?.filter { coin in
            favoriteCoins.contains(where: { favoriteCoin in
                favoriteCoin.marketCode == coin.marketCode
            })
        }
        
        guard var filteredData = filteredData,
              var data = coinList?.data?.markets else { return }
        
        for index in filteredData.indices {
            filteredData[index].isFavorite = true
            data = data.filter { $0.marketCode != filteredData[index].marketCode}
            data.append(filteredData[index])
        }
        self.filteredCoinList = data
    }
    
    func isFavoriteControl(index: Int) {
        if favoriteCoins.contains(where: { $0.marketCode == filteredCoinList[index].marketCode }){
            favoriteCoins = favoriteCoins.filter { $0.marketCode != filteredCoinList[index].marketCode }
            UserDefaults.standard.removeObject(forKey: "coinList")
            UserDefaults.standard.set(favoriteCoins.encode(), forKey: "coinList")
        } else {
            favoriteCoins.append(filteredCoinList[index])
            UserDefaults.standard.set(favoriteCoins.encode(), forKey: "coinList")
        }
        filterData()
    }
    
    func contentsFill() {
        readData()
        filterData()
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
