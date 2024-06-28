//
//  StockViewController.swift
//  Stock Zone
//
//  Created by  Bouncy Baby on 6/28/24.
//

import UIKit

class StockViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view controller's title
        self.title = "StockZ"
        
        // Set the background color to system teal
        view.backgroundColor = UIColor.systemTeal
        
        // Set navigation bar title
        self.navigationItem.title = "StockZ"
        
        // Ensure navigation bar is not hidden (optional, but useful for debugging)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        // Do any additional setup after loading the view.
    }
}
