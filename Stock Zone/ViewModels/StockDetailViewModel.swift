//
//  StockDetailViewModel.swift
//  Stock Zone
//
//  Created by  Bouncy Baby on 7/2/24.
//

import Foundation
import RxSwift
import RxCocoa

class StockDetailViewModel {
    
    let fetchStockDetailsTrigger = PublishSubject<String>()
    
    let stockDetails = BehaviorRelay<StockSnapshotResponse.DayData?>(value: nil)
    
    private let disposeBag = DisposeBag()
    
    init() {
        setupBindings()
    }
    
    private func setupBindings() {
        fetchStockDetailsTrigger
            .flatMapLatest { ticker in
                return NetworkManager.fetchStockDetails(for: ticker)
                    .catchAndReturn(nil) // Catch and return nil if any error occurs
            }
            .bind(to: stockDetails)
            .disposed(by: disposeBag)
    }
}
