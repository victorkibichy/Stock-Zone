//
//  StockViewMode.swift
//  Stock Zone
//
//  Created by  Bouncy Baby on 6/28/24.
//

import RxSwift
import RxCocoa

class StockViewModel {
    private let networkManager = NetworkManager()
    private let disposeBag = DisposeBag()
    
    var tickers = BehaviorRelay<[Ticker]>(value: [])
    private var currentOffset = 0
    private let limit = 100
    private var isFetching = false
    private var hasMoreData = true
    
    func fetchAllTickersRx() {
        guard !isFetching && hasMoreData else { return }
        isFetching = true
        
        networkManager.fetchTickers(limit: limit, offset: currentOffset)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] newTickers in
                    guard let self = self else { return }
                    if newTickers.count < self.limit {
                        self.hasMoreData = false
                    }
                    self.tickers.accept(self.tickers.value + newTickers)
                    self.currentOffset += self.limit
                    self.isFetching = false
                },
                onError: { [weak self] error in
                    print("Error fetching tickers: \(error)")
                    self?.isFetching = false
                }
            )
            .disposed(by: disposeBag)
    }
    
    func loadMoreTickers() {
        fetchAllTickersRx()
    }
    
    func searchTickers(query: String) {
        guard !query.isEmpty else {
            fetchAllTickersRx() // If the query is empty, load initial data
            return
        }
        
        networkManager.searchTickers(query: query)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] searchResults in
                    self?.tickers.accept(searchResults)
                },
                onError: { error in
                    print("Error searching tickers: \(error)")
                }
            )
            .disposed(by: disposeBag)
    }
}
