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
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view controller's title
        self.title = "StockZ"
        
        // Set the background color to system teal
        view.backgroundColor = UIColor.systemTeal
        
        // Setup the navigation bar
        self.navigationItem.title = "StockZ"
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        setupTableView()
        bindViewModel()
        
        viewModel.fetchAllTickersRx()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // Register a cell for the table view
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "StockCell")
        
        // Set constraints for the table view
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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
        tableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                print("Selected ticker at \(indexPath.row)")
            })
            .disposed(by: disposeBag)
    }
}
