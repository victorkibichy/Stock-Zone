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
    
    private let detailTitle = UILabel()
    private let highLabel = UILabel()
    private let lowLabel = UILabel()
    private let volumeLabel = UILabel()
    private let openingPriceLabel = UILabel()
    private let closingPriceLabel = UILabel()
    private let stockImageView = UIImageView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let refreshControl = UIRefreshControl() //for network refresh functions in thr page
    
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
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.systemBackground.cgColor, UIColor.systemTeal.cgColor]
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.refreshControl = refreshControl
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        detailTitle.text = "Today's Details"
        detailTitle.font = UIFont.boldSystemFont(ofSize: 24)
        detailTitle.textAlignment = .center
        detailTitle.textColor = .black
        detailTitle.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(detailTitle)
        
        let stackView = UIStackView(arrangedSubviews: [highLabel, lowLabel, volumeLabel, openingPriceLabel, closingPriceLabel])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        [highLabel, lowLabel, volumeLabel, openingPriceLabel, closingPriceLabel].forEach {
            $0.textColor = .black
            $0.font = UIFont.systemFont(ofSize: 18)
            $0.textAlignment = .center
        }
        
        stockImageView.image = UIImage(named: "Stockyy")
        stockImageView.contentMode = .scaleAspectFit
        stockImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(stockImageView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            detailTitle.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 32),
            detailTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            detailTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            stackView.topAnchor.constraint(equalTo: detailTitle.bottomAnchor, constant: 32),
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            stockImageView.heightAnchor.constraint(equalToConstant: 300) 
        ])
    }

    private func setupBindings() {
        viewModel.stockDetails
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] dayData in
                self?.highLabel.text = "High: \(dayData.h)"
                self?.lowLabel.text = "Low: \(dayData.l)"
                self?.volumeLabel.text = "Volume: \(dayData.v)"
                self?.openingPriceLabel.text = "Opening: \(dayData.o)"
                self?.closingPriceLabel.text = "Closing: \(dayData.c)"
                self?.refreshControl.endRefreshing()
            })
            .disposed(by: disposeBag)
    }
    
    @objc private func refreshData() {
        if let ticker = ticker {
            viewModel.fetchStockDetailsTrigger.onNext(ticker.ticker)
        }
    }
}
