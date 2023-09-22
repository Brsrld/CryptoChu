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
    
    // MARK: - Properties
    lazy var coinListTableView: UITableView = {
        let table = UITableView()
        return table
    }()
    
    private let emptySuperView: UIView = {
        let view = UIView()
        return view
    }()
    
    private var viewModel: ListAllCoinViewModel
    private var coordinator: Coordinator
    
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
            self.viewModel.serviceInit()
            self.prepareUI()
            self.view.backgroundColor = .white
        case .loading:
            self.view.activityStartAnimating()
        case .finished:
            self.view.activityStopAnimating()
            self.viewModel.contentsFill()
            self.prepareEmptyView(isHidden: true)
            self.coinListTableView.reloadData()
        case .error(error: let error):
            self.alert(message: error)
        case .filterSuccess:
            self.coinListTableView.reloadData()
        }
    }
    
    private func prepareUI() {
        title = "Coin List"
        navigationController?.navigationBar.prefersLargeTitles = true
        prepareTableView()
    }
    
    private func prepareTableView() {
        view.addSubview(coinListTableView)
        coinListTableView.register(ListAllCoinTableViewCell.self,
                                   forCellReuseIdentifier: String(describing: ListAllCoinTableViewCell.self))
        
        coinListTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
            make.bottom.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
        }
        coinListTableView.dataSource = self
    }
    
    private func prepareEmptyView(isHidden: Bool) {
        let item = EmptyViewItems(title: "There is no data",
                                  image: "cart.badge.minus")
        
        let emptyView = EmptyView(item: item)
        
        self.emptySuperView.addSubview(emptyView)
        view.addSubview(emptySuperView)
        
        emptySuperView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
            make.height.equalToSuperview().dividedBy(6)
        }
        
        emptyView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(emptySuperView.snp.width)
            make.height.equalTo(emptySuperView.snp.height)
        }
        
        emptySuperView.isHidden = isHidden
    }
}

// MARK: - UITableViewDataSource
extension ListAllCoinViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredCoinList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:  String(describing: ListAllCoinTableViewCell.self),
                                                       for: indexPath) as? ListAllCoinTableViewCell
        else { return UITableViewCell()}
            
        let isChecked = viewModel.filteredCoinList[indexPath.row].isFavorite
        cell.setUpContents(item: ListAllCoinTableViewCellItems(baseCurrency:
                                                                viewModel.filteredCoinList[indexPath.row].baseCurrency,
                                                               counterCurrency: viewModel.filteredCoinList[indexPath.row].counterCurrencyName,
                                                               indexPath: indexPath.row,
                                                               buttonImage: isChecked ? "star.fill" : "star",
                                                               delegate: self))
        
        return cell
    }
}

// MARK: - ListAllCoinTableViewCellOutputProtocol
extension ListAllCoinViewController: ListAllCoinTableViewCellOutputProtocol {
    func onTapped(indexPath: Int?) {
        guard let indexPath = indexPath else { return }
        viewModel.isFavoriteControl(index: indexPath)
        coinListTableView.reloadData()
    }
}
