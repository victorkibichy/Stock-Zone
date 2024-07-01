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

    // MARK: - Properties
    private let viewModel = StockViewModel()
    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindViewModel()
        
        // Fetch the initial list of tickers
        viewModel.fetchAllTickersRx()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        // Set the view controller's title
        self.title = "StockZ"
        view.backgroundColor = UIColor.systemTeal
        
        // Setup the navigation bar
        self.navigationItem.title = "StockZ"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        // Add search button to the navigation bar
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar))
        self.navigationItem.rightBarButtonItem = searchButton
        
        setupSearchBar()
        setupTableView()
    }
    
    private func setupSearchBar() {
        // Configure the search bar
        searchBar.placeholder = "Search Stocks"
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.isHidden = true // Hide initially
        
        // Add the search bar to the view
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
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        // Bind tickers to the table view
        viewModel.tickers
            .bind(to: tableView.rx.items(cellIdentifier: "StockCell")) { index, ticker, cell in
                cell.textLabel?.text = "\(ticker.ticker) - \(ticker.name)"
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            }
            .disposed(by: disposeBag)
        
        // Handle row selection
        tableView.rx.modelSelected(Ticker.self)
            .subscribe(onNext: { [weak self] ticker in
                guard let self = self else { return }
                self.showStockDetails(ticker)
            })
            .disposed(by: disposeBag)
        
        // Handle table view scroll for pagination
        tableView.rx.contentOffset
            .subscribe(onNext: { [weak self] contentOffset in
                guard let self = self else { return }
                let contentHeight = self.tableView.contentSize.height
                let scrollPosition = contentOffset.y + self.tableView.frame.size.height
                
                if scrollPosition > contentHeight - 100 { // Fetch more when 100 points before the bottom
                    self.viewModel.loadMoreTickers()
                }
            })
            .disposed(by: disposeBag)
        
        // Bind search bar text to trigger search
        searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] query in
                self?.viewModel.searchTickers(query: query)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Actions
    @objc private func showSearchBar() {
        searchBar.isHidden = !searchBar.isHidden
        if !searchBar.isHidden {
            searchBar.becomeFirstResponder() // Focus the search bar
        } else {
            searchBar.resignFirstResponder()
            searchBar.text = ""
            viewModel.fetchAllTickersRx() // Reset to initial state
        }
    }
    
    // MARK: - Navigation
    private func showStockDetails(_ ticker: Ticker) {
        let detailVC = StockDetailViewController()
        detailVC.stock = ticker // Pass the selected stock data
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension StockViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.isHidden = true
        searchBar.text = ""
        viewModel.fetchAllTickersRx() // Reset to initial state
    }
}
