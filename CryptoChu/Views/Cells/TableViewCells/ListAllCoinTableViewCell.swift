//
//  ListAllCoinTableViewCell.swift
//  CryptoChu
//
//  Created by Barış Şaraldı on 22.09.2023.
//

import UIKit
import SnapKit

class ListAllCoinTableViewCell: UITableViewCell {
    
    weak var delegate: ListAllCoinTableViewCellOutputProtocol?
    var indexPath: IndexPath?
    
    private lazy var coinNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    private var starButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    // MARK: - Functions
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    private func setUpView() {
        contentView.addSubview(starButton)
        contentView.addSubview(coinNameLabel)
        
        coinNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(50)
        }
        
        starButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(150)
        }
        
        starButton.addTarget(self, action:#selector(onClick), for: .touchUpInside)
    }
    
    func setUpContents(item: ListAllCoinTableViewCellItems) {
        self.delegate = item.delegate
        self.indexPath = item.indexPath
        
        guard let baseCurrency = item.baseCurrency,
              let counterCurrency = item.counterCurrency else { return }
        
        self.coinNameLabel.text = "\(baseCurrency)/\(counterCurrency)"
        
        if item.isFavorite == true {
            starButton.setImage(UIImage(systemName: "star.fill")?.resizableImage(withCapInsets: .zero), for: .normal)
        } else {
            starButton.setImage(UIImage(systemName: "star")?.resizableImage(withCapInsets: .zero), for: .normal)
        }
    }
    
    @objc func onClick(sender: UIButton){
        self.delegate?.onTapped(indexPath: self.indexPath)
    }
}
