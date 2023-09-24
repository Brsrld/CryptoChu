//
//  ViewSpy.swift
//  CryptoChuTests
//
//  Created by Barış Şaraldı on 24.09.2023.
//

import Foundation
import Combine
@testable import CryptoChu

class ViewSpy: StatefulView {
    private(set) var numberOfRenderCalls = 0
    @Published private(set) var state: CryptoChu.ListAllCoinStates!
    private(set) var renderPolicyCalled = false
    private(set) var logDescriptionCalled = false
    let viewModel: ListAllCoinViewModel
    
    init(viewModel: ListAllCoinViewModel) {
        self.viewModel = viewModel
    }

    func render(state: CryptoChu.ListAllCoinStates) {
        viewModel.serviceInit()
        self.state = state
    }

    var renderPolicy: RenderPolicy {
        renderPolicyCalled = true
        return .possible
    }

    var logDescription: String {
        logDescriptionCalled = true
        return String(describing: self)
    }
}
