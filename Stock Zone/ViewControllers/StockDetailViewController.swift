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
    
    var ticker: Ticker? 
    
    private let viewModel = StockDetailViewModel()
    private let disposeBag = DisposeBag()
    
    private let detailTitle = UILabel() // Label for "Today's details"
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
            title = ticker.name
            viewModel.fetchStockDetailsTrigger.onNext(ticker.ticker)
        }
    }
    
    private func setupUI() {
        // Gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.systemBackground.cgColor, UIColor.systemTeal.cgColor]
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        // Configure the detail title label
        detailTitle.text = "Today's Details"
        detailTitle.font = UIFont.boldSystemFont(ofSize: 24)
        detailTitle.textAlignment = .center
        detailTitle.textColor = .black
        detailTitle.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(detailTitle)
        
        // Configure the stack view for stock details
        let stackView = UIStackView(arrangedSubviews: [highLabel, lowLabel, volumeLabel, openingPriceLabel, closingPriceLabel])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        // Configure labels styles
        [highLabel, lowLabel, volumeLabel, openingPriceLabel, closingPriceLabel].forEach {
            $0.textColor = .black
            $0.font = UIFont.systemFont(ofSize: 18)
            $0.textAlignment = .center
        }
        
        NSLayoutConstraint.activate([
            detailTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            detailTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            detailTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: detailTitle.bottomAnchor, constant: 32),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
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
