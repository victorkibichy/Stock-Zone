//
//  StockViewController.swift
//  Stock Zone
//
//  Created by  Bouncy Baby on 6/28/24.
//

import UIKit
import RxSwift
import RxCocoa

class StockViewController: UIViewController {
    
    private let viewModel = StockViewModel()
    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    private let disposeBag = DisposeBag()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindViewModel()
        
        viewModel.fetchAllTickersRx()
    }
    
    private func setupUI() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.systemBackground.cgColor, UIColor.systemTeal.cgColor]
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        self.title = "StockZ"
        view.backgroundColor = UIColor.systemTeal
        
        self.navigationItem.title = "StockZ"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar))
        self.navigationItem.rightBarButtonItem = searchButton
        
        setupSearchBar()
        setupTableView()
    }
    
    private func setupSearchBar() {
        searchBar.placeholder = "Search Stocks"
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.isHidden = true
        
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "StockCell")
        
        tableView.refreshControl = refreshControl
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.tickers
            .bind(to: tableView.rx.items(cellIdentifier: "StockCell")) { index, ticker, cell in
                cell.textLabel?.text = "\(ticker.ticker) - \(ticker.name)"
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Ticker.self)
            .subscribe(onNext: { [weak self] ticker in
                guard let self = self else { return }
                self.showStockDetails(ticker)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.contentOffset
            .subscribe(onNext: { [weak self] contentOffset in
                guard let self = self else { return }
                let contentHeight = self.tableView.contentSize.height
                let scrollPosition = contentOffset.y + self.tableView.frame.size.height
                
                if scrollPosition > contentHeight - 100 {
                    self.viewModel.loadMoreTickers()
                }
            })
            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] query in
                self?.viewModel.searchTickers(query: query)
            })
            .disposed(by: disposeBag)
        
        viewModel.tickers
            .subscribe(onNext: { [weak self] _ in
                self?.refreshControl.endRefreshing()
            })
            .disposed(by: disposeBag)
    }
    
    @objc private func showSearchBar() {
        searchBar.isHidden = !searchBar.isHidden
        if !searchBar.isHidden {
            searchBar.becomeFirstResponder()
        } else {
            searchBar.resignFirstResponder()
            searchBar.text = ""
            viewModel.fetchAllTickersRx()
        }
    }
    
    @objc private func refreshData() {
        viewModel.fetchAllTickersRx()
    }
    
    private func showStockDetails(_ ticker: Ticker) {
        let detailVC = StockDetailViewController()
        detailVC.ticker = ticker
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension StockViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.isHidden = true
        searchBar.text = ""
        viewModel.fetchAllTickersRx()
    }
}
