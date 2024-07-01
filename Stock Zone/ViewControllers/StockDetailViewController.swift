//
//  StockDetailViewController.swift
//  Stock Zone
//
//  Created by  Bouncy Baby on 7/1/24.
//
import UIKit

class StockDetailViewController: UIViewController {

    // MARK: - Properties
    var stock: Ticker? // Assuming 'Ticker' is the model for stock data
    
    private let tickerLabel = UILabel()
    private let nameLabel = UILabel()
    private let exchangeLabel = UILabel()
    private let localeLabel = UILabel()
    private let typeLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupUI()
        
        displayStockDetails()
    }
    
    private func setupUI() {
        tickerLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        exchangeLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        localeLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        typeLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        
        let stackView = UIStackView(arrangedSubviews: [tickerLabel, nameLabel, exchangeLabel, localeLabel, typeLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .leading
        
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func displayStockDetails() {
        guard let stock = stock else { return }
        
        tickerLabel.text = "Ticker: \(stock.ticker)"
        nameLabel.text = "Name: \(stock.name)"
        exchangeLabel.text = "Exchange: \(stock.type)"
        localeLabel.text = "Locale: \(stock.name)"
        typeLabel.text = "Type: \(String(describing: stock.type))"
    }
}
