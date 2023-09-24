//
//  ListAllCoinViewModelTest.swift
//  CryptoChuTests
//
//  Created by Barış Şaraldı on 24.09.2023.
//

import Foundation
import XCTest
import Combine
@testable import CryptoChu


class ListAllCoinViewModelTest: XCTestCase {
    private var viewModel: ListAllCoinViewModelProtocol!
    private var filename = "AllCoinList"
    
    override func setUp() {
        super.setUp()
        viewModel = ListAllCoinViewModel(service: MockHttpClient(filename: filename))
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func test_List_All_Coins_Success()  {
        let expectation = expectValue(of: viewModel.statePublisher.eraseToAnyPublisher(),
                                      expectationDescription: "is state idle",
                                      equals: [{ $0 == .idle}])
        wait(for: [expectation.expectation], timeout: 1)
    }
    
    func test_loading_State()  {
        let expectation = expectValue(of: viewModel.statePublisher.eraseToAnyPublisher(),
                                      expectationDescription: "is state loading",
                                      equals: [{ $0 == .loading}])
        viewModel.serviceInit()
        wait(for: [expectation.expectation], timeout: 1)
    }
    
    func test_finished_State() {
        let expectation = expectValue(of: viewModel.statePublisher.eraseToAnyPublisher(),
                                      expectationDescription: "is state finished",
                                      equals: [{ $0 == .finished}])
        viewModel.serviceInit()
        wait(for: [expectation.expectation], timeout: 1)
    }
    
    func test_error_State() {
        filename = "error"
        setUp()
        let expectation = expectValue(of: viewModel.statePublisher.eraseToAnyPublisher(),
                                      expectationDescription: "is state error",
                                      equals: [{ $0 == .error(error: RequestError.invalidURL.customMessage)}])
        viewModel.serviceInit()
        wait(for: [expectation.expectation], timeout: 1)
    }
    
    func test_empty_State() {
        let expectation = expectValue(of: viewModel.statePublisher.eraseToAnyPublisher(),
                                      expectationDescription: "is state empty",
                                      equals: [{ $0 == .empty}])
        viewModel.checkEmptyState()
        wait(for: [expectation.expectation], timeout: 1)
    }
    
    func test_success_data() {
        let expectation = expectValue(of: viewModel.statePublisher.eraseToAnyPublisher(),
                                      expectationDescription: "market succeess",
                                      equals: [{ $0 == .finished && self.viewModel.coinList?.data?.markets?.isEmpty == false }])
        viewModel.serviceInit()
        wait(for: [expectation.expectation], timeout: 3)
    }
    
    func test_add_favorite() {
        let expectation = expectValue(of: viewModel.statePublisher.eraseToAnyPublisher(),
                                      expectationDescription: "add favorite succeess",
                                      equals: [{
            switch $0 {
            case .finished:
                self.viewModel.isFavoriteControl(index: 0)
                self.viewModel.coinList?.data?.markets?.removeAll()
                self.viewModel.readData()
                return self.viewModel.coinList?.data?.markets?.isEmpty == false
            case .idle:
                return false
            case .loading:
                return false
            case .error(_):
                return false
            case .empty:
                return false
            }
        }])
        
        viewModel.serviceInit()
        wait(for: [expectation.expectation], timeout: 1)
    }
    
    func test_search_success() {
        let expectation = expectValue(of: viewModel.statePublisher.eraseToAnyPublisher(),
                                      expectationDescription: "add favorite succeess",
                                      equals: [{
            switch $0 {
            case .finished:
                self.viewModel.searchCoins(text: "btc")
                return self.viewModel.coinList?.data?.markets?.isEmpty == false
            case .idle:
                return false
            case .loading:
                return false
            case .error(_):
                return false
            case .empty:
                return false
            }
        }])
        
        viewModel.serviceInit()
        wait(for: [expectation.expectation], timeout: 1)
    }
}

