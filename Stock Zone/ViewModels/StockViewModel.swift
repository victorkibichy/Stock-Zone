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
    
    // PublishSubject to emit tickers
    var tickers: PublishSubject<[Ticker]> = PublishSubject()
    
    // Function to fetch tickers and bind to tickers PublishSubject
    func fetchAllTickersRx() {
        networkManager.fetchAllTickers()
            .observe(on: MainScheduler.instance) // Ensure updates happen on the main thread
            .subscribe(
                onNext: { [weak self] tickers in
                    self?.tickers.onNext(tickers)
                },
                onError: { error in
                    print("Error fetching tickers: \(error)")
                }
            )
            .disposed(by: disposeBag)
    }
}
