//
//  CoinDetilsViewModelTest.swift
//  CryptoChuTests
//
//  Created by Barış Şaraldı on 24.09.2023.
//

import Foundation
import XCTest
import Combine
@testable import CryptoChu

class CoinDetilsViewModelTest: XCTestCase {
    private var viewModel: CoinDetailsViewModelProtocol!
    private var filename = "TickerInfo"
    
    override func setUp() {
        super.setUp()
        viewModel = CoinDetailsViewModel(marketCode: "Btc",
                                         isFavorite: true,
                                         service: MockHttpClient(filename: filename))
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func test_success_data() {
        let expectation = expectValue(of: viewModel.statePublisher.eraseToAnyPublisher(),
                                      expectationDescription: "ticker succeess",
                                      equals: [{ $0 == .finished && self.viewModel.coinDetails?.data?.ticker?.avg24H != nil }])
        viewModel.serviceInit()
        wait(for: [expectation.expectation], timeout: 1)
    }
}
