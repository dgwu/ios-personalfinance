//
//  LatestExpensesViewController.swift
//  PersonalFinance
//
//  Created by Gun Eight  on 21/01/19.
//  Copyright © 2019 Daniel Gunawan. All rights reserved.
//

import UIKit
import CoreData

class LatestExpensesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let financeManager = FinanceManager.shared
    let transactionFecthControler = FinanceManager.shared.getExpenseResultController(fromDate: nil, toDate: nil)
    var segmentedIndex : Int = 0
    @IBOutlet weak var segmentedUI: UISegmentedControl!
    @IBOutlet weak var tabelExpenses: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try transactionFecthControler.performFetch()
        } catch  {
            print( "error : \(error.localizedDescription)")
        }
        transactionFecthControler.delegate = self
        self.tabelExpenses.delegate = self
        self.tabelExpenses.dataSource = self
        // Do any additional setup after loading the view.
    }
    

    @IBAction func swicthPeriod(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            segmentedIndex = 0
        }else if sender.selectedSegmentIndex == 1{
            
        }else {
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! LatestExpensesTableViewCell
        if let transaction = transactionFecthControler.fetchedObjects?[indexPath.row] {
            if transaction.transactionDate = Date().
        }
        return cell
    }
    
}

extension LatestExpensesViewController : NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tabelExpenses.reloadData()
}
}
