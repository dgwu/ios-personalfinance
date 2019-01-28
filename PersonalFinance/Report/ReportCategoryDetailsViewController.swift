//
//  ReportCategoryDetailsViewController.swift
//  PersonalFinance
//
//  Created by Denis Wibisono on 10/01/19.
//  Copyright © 2019 Daniel Gunawan. All rights reserved.
//

import UIKit
import CoreData

class ReportCategoryDetailsViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var displayedMonth: UILabel!
    @IBOutlet weak var expenseTable: UITableView!
    
    // Passed Parameters:
    var selectedCategory : String = ""
    var currentlyDisplayedDate = Date()
    var backStep = 0
    var transactions = [Transaction]()
    var pageToLoad : Page = .categoryDetails
    
    // End of passed parameters
    
    var decimalSetting = true
    var filteredTransactions = [Transaction]()
    var prevIndex = 0
    
    
    let myFinanceManager = FinanceManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = selectedCategory
        expenseTable.dataSource = self
        expenseTable.delegate = self
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: currentlyDisplayedDate)
        dateFormatter.dateFormat = "YYYY"
        let year = dateFormatter.string(from: currentlyDisplayedDate)
        displayedMonth.text = "\(nameOfMonth) \(year)"
        
        filteredTransactions = filterTransactions(withCategory: selectedCategory)
        
        print ("Selected Category: ", selectedCategory)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print ("viewWillAppear")
        nextButton.isEnabled = backStep == 0 ? false : true
    }
    
    func filterTransactions(withCategory : String) -> [Transaction] {
        
        var tempTrans = [Transaction]()
        var tempData = Transaction()
        
        if pageToLoad == .categoryDetails {
            for transaction in transactions {
                if transaction.category?.desc == selectedCategory {
                    tempData = transaction
                    tempTrans.append(tempData)
                }
            }
        }
        
        return tempTrans
    }
    
    @IBAction func monthToggleButtonTapped(_ sender: UIButton) {
        var date = Date()
        
        if sender.tag == 0 { // Back
            backStep += 1
            date = Calendar.current.date(byAdding: .month, value: -(backStep), to: Date().startOfMonth().endOfDay )!
            loadData(fromDate: date)
            nextButton.isEnabled = true
        } else { // Next
            backStep -= 1
            date = Calendar.current.date(byAdding: .month, value: -(backStep), to: Date().startOfMonth().endOfDay )!
            loadData(fromDate: date)
            nextButton.isEnabled = backStep == 0 ? false : true
        }
        currentlyDisplayedDate = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "YYYY"
        let year = dateFormatter.string(from: date)
        displayedMonth.text = "\(nameOfMonth) \(year)"
    }
    
    func loadData (fromDate date: Date) {
        // REQUEST data untuk bulan ini
        
        let myTransaction = myFinanceManager.getExpenseResultController(fromDate: date.startOfMonth(), toDate: date.endOfMonth().endOfDay) as? NSFetchedResultsController<NSFetchRequestResult>
        myTransaction?.delegate = self
        
        do {
            try myTransaction?.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        
        // LOAD transactions data
        guard let data = myTransaction?.fetchedObjects as? [Transaction] else {return}
        transactions = data
        filteredTransactions = filterTransactions(withCategory: selectedCategory)
        expenseTable.reloadData()
    }
}

extension ReportCategoryDetailsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRow = 0
        if pageToLoad == .categoryDetails {
            for transaction in transactions {
                if transaction.category?.desc == selectedCategory {numberOfRow += 1}
            }
            print ("Number of Row = ", numberOfRow)
            return numberOfRow
        } else {
            return transactions.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expenseCell") as! ReportCategoryDetailsTableViewCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        cell.dateLabel.text = dateFormatter.string(from: currentlyDisplayedDate)
        if transactions[indexPath.row].desc != nil {
            cell.expenseDescLabel.text = transactions[indexPath.row].desc
        } else {
            cell.expenseDescLabel.text = "No Description"
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = decimalSetting ? 2 : 0
        let expenseValue = formatter.string(from: NSNumber(value: transactions[indexPath.row].amount))
        cell.expenseDescValueLabel.text = expenseValue
        return cell
    }
}

extension ReportCategoryDetailsViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // setiap ada perubahan data, func ini akan di call
        // sorting dulu, trus reloadData
        expenseTable.reloadData()
    }
}
