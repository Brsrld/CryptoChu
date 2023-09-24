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
    private var bindings = Set<AnyCancellable>()
    private var viewModel: ListAllCoinViewModel!
    private var filename = "AllCoinList"
    private let marketSuccessExpectation = XCTestExpectation(description: "market succeess")
    private let idleStateExpectation = XCTestExpectation(description: "idle state expectation")
    private let loadingStateExpectation = XCTestExpectation(description: "loading state expectation")
    private let finishedStateExpectation = XCTestExpectation(description: "finished state expectation")
    private let errorStateExpectation = XCTestExpectation(description: "error state expectation")
    private let emptyStateExpectation = XCTestExpectation(description: "empty state expectation")
    
    override func setUp() {
        super.setUp()
        viewModel = ListAllCoinViewModel(service: MockHttpClient(filename: filename))
        
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func test_List_All_Coins_Success()  {
        let view = ViewSpy(viewModel: viewModel)
        viewModel.subscribe(from: view)
        viewModel.state
        view.$state
            .receive(on: RunLoop.main)
            .sink { state in
                switch state {
                case .idle:
                    print("idle")
                case .loading:
                    print("loading")
                case .finished:
                    print("finished")
                case .error(_):
                    print("error")
                case .empty:
                    print("empty")
                case .none:
                    print("empty")
                }
            }
            .store(in: &bindings)
    }
}

