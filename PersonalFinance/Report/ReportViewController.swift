//
//  ReportViewController.swift
//  PersonalFinance
//
//  Created by Denis Wibisono on 09/01/19.
//  Copyright © 2019 Daniel Gunawan. All rights reserved.
//

import UIKit
import CoreData

class ReportViewController: UIViewController {
    @IBOutlet weak var displayedMonth: UILabel!
    @IBOutlet weak var nextMonthButton: UIButton!
    @IBOutlet weak var prevMonthButton: UIButton!
    @IBOutlet weak var topExpensesTable: UITableView!
    @IBOutlet weak var graphBG: UIImageView!
    @IBOutlet weak var noTransactionsLabel: UILabel!
    
    var expenses : [String : Double] = [:]
    var categories : [String] = []
    
    var currentlyDisplayedMonth = 1
    var currentlyDisplayedYear = 2000
    var decimalSetting : Bool = false
    var selectedCategory : String = ""
    var myTransaction : NSFetchedResultsController<NSFetchRequestResult>?
    let myFinanceManager = FinanceManager.shared
    var transactions = [Transaction]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topExpensesTable.delegate = self
        topExpensesTable.dataSource = self
        
        // REQUEST data untuk bulan ini
        myTransaction?.delegate = self
        myTransaction = myFinanceManager.getExpenseResultController(fromDate: Date().startOfMonth(), toDate: Date().endOfMonth().endOfDay) as? NSFetchedResultsController<NSFetchRequestResult>
        
        do {
            try myTransaction?.performFetch()
        } catch {
            print(error.localizedDescription)
        }
       
        /*
         // Buat kalo pindah ke bulan laen
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.month = 5
        components.year = 2019
        components.timeZone = TimeZone.current
        
        let myDate = calendar.date(from: components)
        print ("COBA DATE START OF MONTH: ", myDate!.startOfMonth().description(with: Locale.current), ", ", myDate!.endOfMonth().endOfDay.description(with: Locale.current) )
        */
        
        let chartStackView = UIStackView()
        let stackViewSpacing = 1
        let barWidth = 40
        let stackViewWidth = barWidth * categories.count + ((categories.count - 1) * stackViewSpacing)
        chartStackView.axis = .horizontal
        chartStackView.alignment = .bottom
        chartStackView.distribution = .equalCentering
        chartStackView.spacing = CGFloat(stackViewSpacing)
        chartStackView.frame = CGRect(x: graphBG.frame.midX, y: graphBG.frame.minY, width: CGFloat(stackViewWidth), height: graphBG.frame.height)
        chartStackView.center = CGPoint(x: graphBG.frame.midX, y: graphBG.frame.midY)
        view.addSubview(chartStackView)
        
        // LOAD transactions data
        guard let data = myTransaction?.fetchedObjects as? [Transaction] else {return}
        transactions = data
        expenses = createDictionaryCategoryValue()
        
        // Olah data transactions
        
        print ("Categories: ", categories)
        
        for category in categories {
            let highestExpenseVal = highestExpenseValue()
            let buttonHeight = Float(expenses[category]!) / Float(highestExpenseVal) * (Float(graphBG.bounds.height) * 0.99)
            print ("Button Height", buttonHeight)
            let expenseBarButton = UIButton(frame: CGRect(x: 100, y: 100, width: barWidth, height: Int(buttonHeight)))
            let colorAlpha = 0.4 + (expenses[category]! / highestExpenseVal * 0.6)
            expenseBarButton.backgroundColor = UIColor(displayP3Red: 0.3, green: 0.1, blue: 0.5, alpha: CGFloat(colorAlpha))
            expenseBarButton.translatesAutoresizingMaskIntoConstraints = false;
            let expenseBarHeightConstraint = NSLayoutConstraint(item: expenseBarButton, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: CGFloat(buttonHeight))
            expenseBarButton.addConstraint(expenseBarHeightConstraint)
            expenseBarButton.titleLabel?.text = category
            expenseBarButton.addTarget(self, action: #selector(self.expenseBarButtonTapped(sender:)), for: .touchUpInside)
            print("Bar Position: \(expenseBarButton.frame.minX), \(expenseBarButton.frame.minY)")
            chartStackView.addArrangedSubview(expenseBarButton)
        }
        
        // kalo gak ada transaksi, show "no transactions"
        print ("No Transactions = ", transactions.count)
        if transactions.count == 0 {
            print ("transactions")
            noTransactionsLabel.isHidden = false
            topExpensesTable.isHidden = true
        } else {
            print ("transactions else")
            noTransactionsLabel.isHidden = true
            topExpensesTable.isHidden = false
        }
    } // End of viewDidLoad()
    
    func highestExpenseValue () -> Double {
        var highest : Double = 0
        for expense in expenses {
            if highest < expense.value {
                highest = expense.value
            }
        }
        return highest
    } // end of highestExpenseValue () -> Float
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print ("Selected Category = ", self.selectedCategory)
        if let detailVC = segue.destination as? ReportCategoryDetailsViewController {
            detailVC.selectedCategory = self.selectedCategory
        }
    } // end of prepare(for segue: UIStoryboardSegue, sender: Any?)
    
    @objc func expenseBarButtonTapped (sender: UIButton) {
        self.selectedCategory = (sender.titleLabel?.text)!
        self.performSegue(withIdentifier: "reportDetailSegue", sender: nil)
    }
    
    @IBAction func dateToggleButtonPressed(_ sender: UIButton) {
        
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        
        if sender.tag == 0 { // Back
            
        } else { // Next
            
        }
    }
    
    func createDictionaryCategoryValue () -> [String : Double] {
        var tempDict : [String : Double] = [:]
        for transaction in transactions {
            if (categories.firstIndex(of: (transaction.category?.desc)!) == nil) {
                categories.append(transaction.category!.desc!)
                let value = transaction.amount
                tempDict[(transaction.category?.desc)!] = value
            } else {
                tempDict[(transaction.category?.desc)!]! += transaction.amount
            }
        }
        return tempDict
    }
}


extension ReportViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "topExpenseCell") as! ReportTableViewCell
        cell.rank.text = String(indexPath.row+1)
        cell.expenseCategory.text = categories[indexPath.row]
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = decimalSetting ? 2 : 0
        let expenseValue = formatter.string(from: NSNumber(value: expenses[categories[indexPath.row]]!))
        cell.expenseCategoryValue.text = expenseValue
        return cell
    }
}

extension ReportViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // setiap ada perubahan data, func ini akan di call
        // sorting dulu, trus reloadData
        
        topExpensesTable.reloadData()
    }
}

