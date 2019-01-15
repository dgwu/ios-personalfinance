//
//  CategoryViewController.swift
//  PersonalFinance
//
//  Created by okky pribadi on 14/01/19.
//  Copyright © 2019 Daniel Gunawan. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {
    

    @IBOutlet weak var categoryTable: UITableView!
    let financeManager = FinanceManager.shared
    var categoryList = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    func initialSetup() {
        if let expenseCategory = financeManager.categoryList(type: .expense) {
            categoryList = expenseCategory
        }
        
        // Do any additional setup after loading the view.
        categoryTable.dataSource = self
        categoryTable.delegate = self
    }

    @IBAction func changeCategoryType(_ sender: UISegmentedControl) {
        if sender.titleForSegment(at: sender.selectedSegmentIndex) == "Income" {
            if let incomeCategory = financeManager.categoryList(type: .income) {
                categoryList = incomeCategory
            }
        } else {
            if let expenseCategory = financeManager.categoryList(type: .expense) {
                categoryList = expenseCategory
            }
        }
        
        self.categoryTable.reloadData()
    }
}


// table view extension
extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50))
        sectionView.backgroundColor = UIColor.lightGray
        
        let stackView = UIStackView(frame: CGRect(x: 10, y: 0, width: tableView.bounds.width - 20, height: 50))
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        
        
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width - 30, height: 50))
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.black
        label.text = self.categoryList[section].desc
        
        
        let addSubcategoryButton = UIButton.init(type: .system)
        addSubcategoryButton.frame = CGRect(x: 15, y: 0, width: 20, height: 50)
        addSubcategoryButton.setTitle("+", for: .normal)
        
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(addSubcategoryButton)

        sectionView.addSubview(stackView)
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.categoryList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categoryList[section].childs?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        if let childList = categoryList[indexPath.section].childs, let child = childList[indexPath.row] as? Category {
            cell.textLabel?.text = child.desc
        }
        
        
        
        return cell
    }
}

