//
//  StockDetailViewController.swift
//  Stock Zone
//
//  Created by  Bouncy Baby on 7/1/24.
//

//
//  StockDetailViewController.swift
//  Stock Zone
//
//  Created by Bouncy Baby on 7/1/24.
//

import UIKit
import RxSwift
import RxCocoa

class StockDetailViewController: UIViewController {
    
    var ticker: Ticker? // Property to store the selected stock data
    
    private let viewModel = StockDetailViewModel()
    private let disposeBag = DisposeBag()
    
    private let highLabel = UILabel()
    private let lowLabel = UILabel()
    private let volumeLabel = UILabel()
    private let openingPriceLabel = UILabel()
    private let closingPriceLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBindings()
        
        if let ticker = ticker {
            title = ticker.ticker // Set navigation title to the selected stock symbol or name
            viewModel.fetchStockDetailsTrigger.onNext(ticker.ticker)
        }
    }
    
    private func setupUI() {
        
        view.backgroundColor = .systemBackground
        
        // Layout your labels
        let stackView = UIStackView(arrangedSubviews: [highLabel, lowLabel, volumeLabel, openingPriceLabel, closingPriceLabel])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        // Constraints for the stack view
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupBindings() {
        viewModel.stockDetails
            .compactMap { $0 } // Filter out nil values
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] dayData in
                self?.highLabel.text = "High: \(dayData.h)"
                self?.lowLabel.text = "Low: \(dayData.l)"
                self?.volumeLabel.text = "Volume: \(dayData.v)"
                self?.openingPriceLabel.text = "Opening: \(dayData.o)"
                self?.closingPriceLabel.text = "Closing: \(dayData.c)"
            })
            .disposed(by: disposeBag)
    }
}
