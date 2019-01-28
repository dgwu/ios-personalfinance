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
    func confirmDeleteWallet(_ indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete Wallet", message: nil, preferredStyle: .actionSheet)
        
        if self.walletList.count > 1 {
            let wallet = self.walletList[indexPath.row]
            alert.message = "Are you sure you want to permanently delete \(wallet.desc!)?"
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
                wallet.setValue(false, forKey: "isActive")
                
                do {
                    try self.financeManager.objectContext.save()
                } catch {
                    print(error.localizedDescription)
                }
                
                self.refreshWallet()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
        } else {
            alert.message = "You cant delete the only one wallet."
            let cancelAction = UIAlertAction(title: "Oh, okay.", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.confirmDeleteWallet(indexPath);
        }
    }
    
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
