//
//  
//  ListAllCoinViewController.swift
//  CryptoChu
//
//  Created by Barış Şaraldı on 21.09.2023.
//
//
import UIKit

final class ListAllCoinViewController: UIViewController, StatefulView {
    
    var viewModel: ListAllCoinViewModel
    var coordinator: Coordinator
    
    // MARK: - Base Functions
    init(coordinator: Coordinator,
         viewModel: ListAllCoinViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.subscribe(from: self)
    }
    
    func render(state: ListAllCoinStates) {
        switch state {
        case .idle:
            view.backgroundColor = .red
        }
    }
}
