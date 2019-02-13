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
    @IBOutlet weak var displayedMonthBG: UIImageView!
    @IBOutlet weak var noTransactionIcon: UIImageView!
    @IBOutlet weak var noTransactionLabel: UILabel!
    @IBOutlet var trashButton: UIBarButtonItem!
    
    // Passed Parameters:
    var selectedCategory : String = ""
    var currentlyDisplayedDate = Date() // Passed Parameter
    var backStep = 0
    var transactions = [Transaction]()
    var pageToLoad : Page = .categoryDetails
    var numberOfRow : Int = 0
    // End of passed parameters
    
    lazy var PresentationDelegate = PresentationManager()
    var filteredTransactions = [Transaction]()
    var prevIndex = 0
    var selectedTransaction : Transaction?
    let settingManager = SetupManager.shared
    let myFinanceManager = FinanceManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = selectedCategory
        expenseTable.dataSource = self
        expenseTable.delegate = self
        
        displayedMonthBG.layer.cornerRadius = 9
        displayedMonthBG.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        displayedMonthBG.layer.borderWidth = 1
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: currentlyDisplayedDate)
        dateFormatter.dateFormat = "YYYY"
        let year = dateFormatter.string(from: currentlyDisplayedDate)
        displayedMonth.text = "\(nameOfMonth) \(year)"
        
        print ("Selected Category: ", selectedCategory)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        trashButton.tag = 0
        trashButton.title = "Delete"
        expenseTable.setEditing(false, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        filteredTransactions.removeAll()
        loadData(fromDate: currentlyDisplayedDate)
        if pageToLoad == .categoryDetails {
            filteredTransactions = filterTransactions(withCategory: selectedCategory)
        } else {
            filteredTransactions = transactions
        }
        nextButton.isEnabled = backStep == 0 ? false : true
        checkTransactions()
        expenseTable.reloadData()
    }
    
    func checkTransactions() {
        if filteredTransactions.count == 0 {
            noTransactionIcon.isHidden = false
            noTransactionLabel.isHidden = false
        } else {
            noTransactionIcon.isHidden = true
            noTransactionLabel.isHidden = true
        }
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
        print ("Load Data...")
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
        
        if pageToLoad == .categoryDetails {
            filteredTransactions = filterTransactions(withCategory: selectedCategory)
        } else {
            filteredTransactions = transactions
        }
        checkTransactions()
        expenseTable.reloadData()
    }
    
    @IBAction func editButton(_ sender: UIBarButtonItem) {
        if sender.tag == 0 {
            sender.tag = 1
            trashButton.title = "Done"
            expenseTable.setEditing(true, animated: true)
        } else {
            sender.tag = 0
            trashButton.title = "Delete"
//            trashButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: nil)
            expenseTable.setEditing(false, animated: true)
        }
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let editVC = segue.destination as? CardViewRecordVC {
            editVC.transitioningDelegate = PresentationDelegate
            editVC.modalPresentationStyle = .custom
            editVC.transactionSelected = self.selectedTransaction
            editVC.categorySelected = self.selectedTransaction?.category
            editVC.title = "Edit Transaction"
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: ReportCategoryDetailsTableViewCell) {
//        if let editVC = segue.destination as? CardViewRecordVC {
//            editVC.title = "Edit Transaction"
//
//        }
//    } // end of prepare(for segue: UIStoryboardSegue, sender: Any?)
    
}

extension ReportCategoryDetailsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if pageToLoad == .categoryDetails {
            numberOfRow = 0
            for transaction in transactions {
                if transaction.category?.desc == selectedCategory {numberOfRow += 1}
            }
            print ("Number of Row = ", numberOfRow)
            return numberOfRow
        } else {
            numberOfRow = filteredTransactions.count
            return numberOfRow
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print ("\(String(describing: filteredTransactions[indexPath.row].category?.desc)) Selected")
        self.selectedTransaction = filteredTransactions[indexPath.row]
        performSegue(withIdentifier: "editTransaction", sender: nil)
        
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print ("\(filteredTransactions[indexPath.row].amount) DELETED; ROW: \(indexPath.row)")
            
            let transactionData = filteredTransactions[indexPath.row]
            let context = myFinanceManager.objectContext
            context.delete(transactionData)
            
            do {
                try context.save()
                filteredTransactions.remove(at: indexPath.row)
                expenseTable.deleteRows(at: [indexPath], with: .left)
//                loadData(fromDate: currentlyDisplayedDate)
//                expenseTable.reloadData()
            } catch {
                // error handling
                print(error.localizedDescription)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expenseCell") as! ReportCategoryDetailsTableViewCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let dateLabelWidth = cell.dateLabel.font.pointSize * 2.5
//        print ("FILTERED TRANSACTION AT ROW = ", filteredTransactions[indexPath.row])
        cell.dateLabel.text = dateFormatter.string(from: filteredTransactions[indexPath.row].transactionDate!)
        cell.dateLabel.layer.borderWidth = dateLabelWidth / 8
        cell.dateLabel.layer.cornerRadius = dateLabelWidth / 2
        cell.dateLabel.widthAnchor.constraint(equalToConstant: dateLabelWidth).isActive = true
        cell.transactionObject = filteredTransactions[indexPath.row]
        
        if pageToLoad == .reportDetails {
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .blue
        } else {
            cell.accessoryType = .none
            cell.selectionStyle = .none
        }        
        
        let borderColor = filteredTransactions[indexPath.row].category!.colorCode!
        cell.dateLabel.layer.borderColor = UIColor(hexString: borderColor).cgColor
        
        if filteredTransactions[indexPath.row].desc != "-" {
            cell.expenseDescLabel.text = filteredTransactions[indexPath.row].desc
            cell.expenseDescLabel.font = UIFont.systemFont(ofSize: cell.expenseDescLabel.font.pointSize)
            cell.expenseDescLabel.alpha = 1
        } else {
            cell.expenseDescLabel.text = filteredTransactions[indexPath.row].category?.desc
            cell.expenseDescLabel.font = UIFont.italicSystemFont(ofSize: cell.expenseDescLabel.font.pointSize)
            cell.expenseDescLabel.alpha = 0.3
        }
        
        let locale = Locale.current
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = SetupManager.shared.isUserUsingDecimal ? 2 : 0
        formatter.maximumFractionDigits = SetupManager.shared.isUserUsingDecimal ? 2 : 0
        let expenseValue = locale.currencySymbol! + " " + formatter.string(from: NSNumber(value: filteredTransactions[indexPath.row].amount))!
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
