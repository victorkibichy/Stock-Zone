//
//  StockViewController.swift
//  Stock Zone
//
//  Created by  Bouncy Baby on 6/28/24.
//

import UIKit

class StockViewController: UIViewController {

    // MARK: - Properties
    private let viewModel = StockViewModel()
    private let tableView = UITableView()
    
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
        
        configureViewModel()
        
        viewModel.fetchAllTickers()
    }
    
    // MARK: - UI Setup
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        
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
    
    // MARK: - Configure ViewModel
    private func configureViewModel() {
        // Bind the update UI callback
        viewModel.updateUI = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        // Handle errors
        viewModel.onError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.showErrorAlert(message: errorMessage)
            }
        }
    }
    
    // MARK: - Show Error Alert
    private func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension StockViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tickers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockCell", for: indexPath)
        let ticker = viewModel.tickers[indexPath.row]
        cell.textLabel?.text = ticker
        
        return cell
    }
}
