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
    var selectedWallet: Wallet?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        walletTableView.dataSource = self
        walletTableView.delegate = self
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(viewWalletDetail))
        self.navigationItem.rightBarButtonItem = addButton
        
        refreshWallet()
    }
    
    @objc func viewWalletDetail() {
        let detailWalletVC = WalletDetailViewController()
        detailWalletVC.delegate = self
        detailWalletVC.wallet = self.selectedWallet
        
        let navigationController = UINavigationController(rootViewController: detailWalletVC)
        navigationController.modalTransitionStyle = .coverVertical
        navigationController.modalPresentationStyle = .overCurrentContext
        
        self.present(navigationController, animated: true, completion: nil)
        
        // reset setelah present
        self.selectedWallet = nil
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedWallet = walletList[indexPath.row]
        self.viewWalletDetail()
        tableView.deselectRow(at: indexPath, animated: false)
    }
}


extension WalletViewController: WalletDetailViewControllerDelegate {
    func walletUpdate() {
        self.refreshWallet()
    }
}
