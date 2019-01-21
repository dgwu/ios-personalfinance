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
    var selectedCategory = CategoryType.expense
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    func initialSetup() {
        // setup navigation bar
        self.navigationItem.title = "Category"
        let addCategoryButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(segueToAddCategory))
        self.navigationItem.rightBarButtonItem = addCategoryButton
        
        if let expenseCategory = financeManager.categoryList(type: .expense) {
            categoryList = expenseCategory
        }
        
        // Do any additional setup after loading the view.
        categoryTable.dataSource = self
        categoryTable.delegate = self
    }
    
    @objc func segueToAddCategory() {
        
        let categoryAddViewController = CategoryAddViewController()
        let newNavigationController = UINavigationController(rootViewController: categoryAddViewController)
        
        newNavigationController.modalPresentationStyle = .overCurrentContext
        newNavigationController.modalTransitionStyle = .coverVertical
        categoryAddViewController.delegate = self
        categoryAddViewController.selectedCategory = self.selectedCategory
        self.present(newNavigationController, animated: true, completion: nil)
    }

    @IBAction func changeCategoryType(_ sender: UISegmentedControl) {
        if sender.titleForSegment(at: sender.selectedSegmentIndex) == "Income" {
            self.selectedCategory = .income
        } else {
            self.selectedCategory = .expense
        }
        
        if let expenseCategory = financeManager.categoryList(type: self.selectedCategory) {
            categoryList = expenseCategory
        }
        
        self.categoryTable.reloadData()
    }
}


// table view extension
extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categoryList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryTableViewCell
        
        let category = categoryList[indexPath.row]
        cell.categoryDescLabel.text = category.desc
        cell.categoryIconImageView.image = UIImage(named: category.iconName!)
        
        return cell
    }
}



extension CategoryViewController: CategoryAddDelegate {
    func categoryUpdate() {
        if let expenseCategory = financeManager.categoryList(type: self.selectedCategory) {
            categoryList = expenseCategory
        }
        
        self.categoryTable.reloadData()
    }
    
}
