//
//  WalletViewController.swift
//  PersonalFinance
//
//  Created by Daniel Gunawan on 21/01/19.
//  Copyright © 2019 Daniel Gunawan. All rights reserved.
//

import UIKit

class WalletViewController: UIViewController {
    
    @IBOutlet weak var walletTableView: UITableView!
    let financeManager = FinanceManager.shared
    var walletList = [Wallet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        walletTableView.dataSource = self
        walletTableView.delegate = self
        
        refreshWallet()
    }
    
    func refreshWallet() {
        if let walletList = financeManager.walletList() {
            self.walletList = walletList
        }
        self.walletTableView.reloadData()
    }

}


extension WalletViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return walletList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletCell", for: indexPath) as! WalletTableViewCell
        
        let wallet = walletList[indexPath.row]
        cell.wallet = wallet
        
        return cell
    }
    
    
}
