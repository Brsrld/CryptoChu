//
//  
//  ListAllCoinViewController.swift
//  CryptoChu
//
//  Created by Barış Şaraldı on 21.09.2023.
//
//
import UIKit
import Combine

final class ListAllCoinViewController: UIViewController {
    
    // MARK: - Properties
    private lazy var coinListTableView: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    private let emptySuperView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var searchBar: UISearchBar = {
       let search = UISearchBar()
        search.placeholder = "Search coin..."
        search.searchBarStyle = .minimal
        search.delegate = self
        return search
    }()
    
    private var viewModel: ListAllCoinViewModelProtocol
    private var coordinator: Coordinator
    private var cancellables: Set<AnyCancellable>
    
    // MARK: - Base Functions
    init(coordinator: Coordinator,
         viewModel: ListAllCoinViewModelProtocol) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        self.cancellables = []
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleStates()
    }
    
    private func handleStates() {
        viewModel.statePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] (state) in
                switch state {
                case .idle:
                    self?.fillData()
                    self?.prepareUI()
                case .loading:
                    self?.view.activityStartAnimating()
                case .finished:
                    self?.view.activityStopAnimating()
                    self?.prepareEmptyView(isHidden: true)
                    self?.coinListTableView.reloadData()
                case .error(error: let error):
                    self?.alert(message: error)
                case .empty:
                    self?.prepareEmptyView(isHidden: false)
                }
            }.store(in: &cancellables)
    }
    
    private func fillData() {
        viewModel.serviceInit()
        viewModel.readData()
        viewModel.checkEmptyState()
    }
    
    private func prepareUI() {
        title = "Coin List"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        prepareTableView()
    }
    
    private func prepareTableView() {
        view.addSubview(coinListTableView)
        view.addSubview(searchBar)
        coinListTableView.register(ListAllCoinTableViewCell.self,
                                   forCellReuseIdentifier: String(describing: ListAllCoinTableViewCell.self))
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(32)
        }
        
        coinListTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(12)
            make.bottom.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
        }
    }
    
    private func prepareEmptyView(isHidden: Bool) {
        let item = EmptyViewItems(title: "There is no data",
                                  image: "bitcoinsign.circle.fill")
        
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

// MARK: -  UITableViewDataSource, UITableViewDelegate
extension ListAllCoinViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = viewModel.coinList?.data?.markets?.count else { return 0}
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:  String(describing: ListAllCoinTableViewCell.self),
                                                       for: indexPath) as? ListAllCoinTableViewCell
        else { return UITableViewCell()}
        
        cell.setUpContents(item: ListAllCoinTableViewCellItems(baseCurrency:
                                                                viewModel.coinList?.data?.markets?[indexPath.row].baseCurrency,
                                                               counterCurrency: viewModel.coinList?.data?.markets?[indexPath.row].counterCurrency,
                                                               indexPath: indexPath,
                                                               isFavorite: viewModel.coinList?.data?.markets?[indexPath.row].isFavorite,
                                                               delegate: self))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let marketCode = viewModel.coinList?.data?.markets?[indexPath.row].marketCode,
              let isFavorite = viewModel.coinList?.data?.markets?[indexPath.row].isFavorite else { return }
        coordinator.eventOccurred(with: CoinDetailsBuilder.build(coordinator: coordinator, marketCode: marketCode, isFavorite: isFavorite))
    }
}


// MARK: - ListAllCoinTableViewCellOutputProtocol
extension ListAllCoinViewController: ListAllCoinTableViewCellOutputProtocol {
    func onTapped(indexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        viewModel.isFavoriteControl(index: indexPath.row)
        self.coinListTableView.reloadRows(at: [indexPath], with: .fade)
    }
}

// MARK: - UISearchBarDelegate
extension ListAllCoinViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchCoins(text: searchText)
        self.coinListTableView.reloadData()
    }
}
