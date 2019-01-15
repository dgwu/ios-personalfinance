//
//  ReportCategoryDetailsViewController.swift
//  PersonalFinance
//
//  Created by Denis Wibisono on 10/01/19.
//  Copyright © 2019 Daniel Gunawan. All rights reserved.
//

import UIKit

class ReportCategoryDetailsViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var displayedMonthLabel: UILabel!
    @IBOutlet weak var expenseTable: UITableView!
    
    var selectedCategory : String = ""
    var displayedMonth : String = "January"
    var displayedYear : Int = 2019
    
    var expenses : [String : Float] = ["Makan" : 200000, "Belanja" : 300000, "Nonton" : 150000, "Parkir" : 55000]
    var decimalSetting = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = selectedCategory
        expenseTable.dataSource = self
        expenseTable.delegate = self
        self.displayedMonthLabel.text = "\(displayedMonth), \(displayedYear)"
        let myFinanceManager = FinanceManager.shared
        
    }
}

extension ReportCategoryDetailsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expenseCell") as! ReportCategoryDetailsTableViewCell
        cell.rankLabel.text = String(indexPath.row+1)
        let key = Array(expenses.keys)[indexPath.row]
        cell.expenseDescLabel.text = key
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = decimalSetting ? 2 : 0
        let expenseValue = formatter.string(from: NSNumber(value: expenses[key]!))
        cell.expenseDescValueLabel.text = expenseValue
        return cell
    }
    
    
    
}
