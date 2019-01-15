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
    
    var expenses : [String : Float] = ["Makan" : 200000, "Belanja" : 300000, "Nonton" : 150000, "Parkir" : 55000]
    var categories : [String] = ["Makan", "Parkir", "Belanja", "Nonton"]
    
    var currentlyDisplayedMonth = 1
    var currentlyDisplayedYear = 2000
    var decimalSetting : Bool = false
    var selectedCategory : String = ""
    var myTransaction : NSFetchedResultsController<NSFetchRequestResult>?
    let myFinanceManager = FinanceManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topExpensesTable.delegate = self
        topExpensesTable.dataSource = self
        noTransactionsLabel.isEnabled = false
        
        myTransaction = myFinanceManager.getExpenseResultController(fromDate: Date().startOfMonth(), toDate: Date().endOfMonth().endOfDay) as? NSFetchedResultsController<NSFetchRequestResult>
        
        myTransaction?.delegate = self
        do {
            try myTransaction?.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        
//        print ("myTransactions: ", myTransaction?.fetchedObjects!)
        noTransactionsLabel.isEnabled = myTransaction?.fetchedObjects! == nil ? false : true
       
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
        
        for category in categories {
            let highestExpenseVal = highestExpenseValue()
            let buttonHeight = expenses[category]! / highestExpenseVal * (Float(graphBG.bounds.height) * 0.99)
            print ("Button Height", buttonHeight)
            let expenseBarButton = UIButton(frame: CGRect(x: 0, y: 0, width: barWidth, height: Int(buttonHeight)))
            let blueColor = 0.4 + (expenses[category]! / highestExpenseVal * 0.6)
            expenseBarButton.backgroundColor = UIColor(displayP3Red: 0.3, green: 0.1, blue: 0.5, alpha: CGFloat(blueColor))
            expenseBarButton.translatesAutoresizingMaskIntoConstraints = false;
            let expenseBarHeightConstraint = NSLayoutConstraint(item: expenseBarButton, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: CGFloat(buttonHeight))
            expenseBarButton.addConstraint(expenseBarHeightConstraint)
            expenseBarButton.titleLabel?.text = category
            expenseBarButton.addTarget(self, action: #selector(self.expenseBarButtonTapped(sender:)), for: .touchUpInside)
            chartStackView.addArrangedSubview(expenseBarButton)
        }
        
        guard let transactions = myTransaction?.fetchedObjects as? [Transaction] else {return}
        for transaction in transactions {
            print("transaction amount = ", transaction.amount)
            
        }
    }
    
    func highestExpenseValue () -> Float {
        var highest : Float = 0
        for category in categories {
            if highest < expenses[category]!{
                highest = expenses[category]!
            }
        }
        return highest
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print ("Selected Category = ", self.selectedCategory)
        if let detailVC = segue.destination as? ReportCategoryDetailsViewController {
            detailVC.selectedCategory = self.selectedCategory
        }
    }
    
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
    
}

extension ReportViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRow = categories.count
            return numberOfRow
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
        // run code kalo ada perubahan data:
        
    }
}

