//
//  
//  CoinDetailsViewController.swift
//  CryptoChu
//
//  Created by Barış Şaraldı on 23.09.2023.
//
//
import UIKit
import Combine

final class CoinDetailsViewController: UIViewController {
    
    private lazy var coinStatusView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    private lazy var coinNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    private lazy var lastPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    private lazy var lastSizeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    private lazy var pastDayLowLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    private lazy var pastDayHighLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    private lazy var pastDayAvgLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.leading
        stackView.spacing = 12
        return stackView
    }()
    
    private var viewModel: CoinDetailsViewModelProtocol
    private var coordinator: Coordinator
    private var cancellables: Set<AnyCancellable>
    private var timer = Timer()
    
    // MARK: - Base Functions
    init(coordinator: Coordinator,
         viewModel: CoinDetailsViewModelProtocol) {
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
    
    func handleStates() {
        viewModel.statePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] (state) in
                switch state {
                case .idle:
                    self?.viewModel.serviceInit()
                    self?.prepareUI()
                case .loading:
                    self?.view.activityStartAnimating()
                case .finished:
                    self?.view.activityStopAnimating()
                    self?.fillUIComponents()
                    self?.reSendRequest()
                case .error(let error):
                    self?.alert(message: error)
                }
            }.store(in: &cancellables)
    }
    
    private func prepareUI() {
        title = "Coin Detail"
        navigationController?.navigationBar.prefersLargeTitles = false
        self.view.backgroundColor = .white
        
        coinStatusView.addSubview(coinNameLabel)
        labelStackView.addArrangedSubview(lastPriceLabel)
        labelStackView.addArrangedSubview(pastDayAvgLabel)
        labelStackView.addArrangedSubview(pastDayLowLabel)
        labelStackView.addArrangedSubview(pastDayHighLabel)
        labelStackView.addArrangedSubview(lastSizeLabel)
        view.addSubview(coinStatusView)
        view.addSubview(labelStackView)
        
        coinStatusView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(48)
        }
        
        coinNameLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(48)
        }
        
        labelStackView.snp.makeConstraints { make in
            make.top.equalTo(coinStatusView.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
        }
        
        coinStatusView.clipsToBounds = true
        coinStatusView.layer.cornerRadius = 12
        setUpLeftImage()
    }
    
    private func setUpLeftImage() {
        let condition = viewModel.isFavorite == "star.fill"
        let logoImage = UIImage(systemName: condition ? "star.fill" : "star")
        let logoImageView = UIImageView(image: logoImage)
        logoImageView.contentMode = .scaleAspectFit
        let imageItem = UIBarButtonItem(customView: logoImageView)
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        navigationItem.rightBarButtonItems = [negativeSpacer, imageItem]
    }
    
    private func changeCoinStatus () -> UIColor {
        guard let change24h = viewModel.coinDetails?.data?.ticker?.change24H else { return .gray }
        let changeCoinStatus = Double(change24h)?.sign
        
        switch changeCoinStatus {
        case .plus:
            return .green
        case .minus:
            return .red
        case .none:
            return .gray
        }
    }
    
    private func reSendRequest() {
        DispatchQueue.main.async { [weak self] in
            self?.timer = Timer.scheduledTimer(withTimeInterval: 6,
                                               repeats: false, block: {_ in
                self?.viewModel.serviceInit()
            })
        }
    }
    
    private func fillUIComponents() {
        guard let size = viewModel.coinDetails?.data?.ticker?.lastSize,
              let price = viewModel.coinDetails?.data?.ticker?.lastPrice,
              let avg24h = viewModel.coinDetails?.data?.ticker?.avg24H,
              let low24h = viewModel.coinDetails?.data?.ticker?.low24H,
              let high24h = viewModel.coinDetails?.data?.ticker?.high24H,
              let currency = viewModel.coinDetails?.data?.ticker?.market?.counterCurrencyCode else { return }
        
        coinStatusView.backgroundColor = changeCoinStatus()
        coinNameLabel.text = viewModel.coinDetails?.data?.ticker?.market?.marketCode
        
        lastSizeLabel.text = "Last size: \(size)"
        lastPriceLabel.text = "Last price: \(price) \(currency)"
        pastDayAvgLabel.text = "Past 24h Avarage price: \(avg24h) \(currency)"
        pastDayLowLabel.text = "Past 24h Low price: \(low24h) \(currency)"
        pastDayHighLabel.text = "Past 24h Last high price: \(high24h) \(currency)"
    }
}
