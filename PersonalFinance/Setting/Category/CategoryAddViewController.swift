//
//  CategoryAddViewController.swift
//  PersonalFinance
//
//  Created by Daniel Gunawan on 17/01/19.
//  Copyright © 2019 Daniel Gunawan. All rights reserved.
//

import UIKit

class CategoryAddViewController: UIViewController {
    var staticTableView: UITableView!
    var categoryNameTextField: UITextField!
    var categoryTypeSegmentControl: UISegmentedControl!
    var selectedCategory: CategoryType?
    var delegate: CategoryAddDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    
    func setupView() {
        self.view.backgroundColor = .white
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeThis))
        
        self.navigationItem.title = "Add Category"
        self.navigationItem.leftBarButtonItem = closeButton
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(addCategory))
        self.navigationItem.rightBarButtonItem = saveButton
        
        
        // setup table
        staticTableView = UITableView(frame: self.view.frame, style: UITableView.Style.plain)
        staticTableView.register(UITableViewCell.self, forCellReuseIdentifier: "staticCell")
        
        staticTableView.dataSource = self
        self.view.addSubview(staticTableView)
        
    }
    
    @objc func addCategory() {
        print("add category")
        
        guard let categoryDesc = self.categoryNameTextField.text else {
            return
        }
        if self.categoryTypeSegmentControl.selectedSegmentIndex == 0 {
            // expense
            FinanceManager.shared.insertCategory(categoryType: .expense, desc: categoryDesc, iconName: "category", colorCode: "red")
        } else {
            // income
            FinanceManager.shared.insertCategory(categoryType: .income, desc: categoryDesc, iconName: "category", colorCode: "blue")
        }
        
        print("category added")
        self.delegate?.categoryUpdate()
        closeThis()
    }
    
    @objc func closeThis() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

}

extension CategoryAddViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let staticCell = tableView.dequeueReusableCell(withIdentifier: "staticCell", for: indexPath)
        
        let staticCellLabel = UILabel()
        staticCellLabel.translatesAutoresizingMaskIntoConstraints = false
        staticCellLabel.font.withSize(20)
        staticCell.addSubview(staticCellLabel)
        NSLayoutConstraint.activate([
            staticCellLabel.leadingAnchor.constraint(equalTo: staticCell.leadingAnchor, constant: 15),
            staticCellLabel.centerYAnchor.constraint(equalTo: staticCell.centerYAnchor)
        ])
        
        if (indexPath.row == 0) {
            staticCellLabel.text = "Name"
            self.categoryNameTextField = UITextField()
            self.categoryNameTextField.placeholder = "Name"
            self.categoryNameTextField.textAlignment = .right
            self.categoryNameTextField.font?.withSize(20)
            self.categoryNameTextField.translatesAutoresizingMaskIntoConstraints = false
            
            staticCell.addSubview(self.categoryNameTextField)
            NSLayoutConstraint.activate([
                self.categoryNameTextField.trailingAnchor.constraint(equalTo: staticCell.trailingAnchor, constant: -15),
                self.categoryNameTextField.centerYAnchor.constraint(equalTo: staticCell.centerYAnchor),
                self.categoryNameTextField.widthAnchor.constraint(equalToConstant: 145)
            ])
            
        } else {
            staticCellLabel.text = "Type"
            self.categoryTypeSegmentControl = UISegmentedControl()
            self.categoryTypeSegmentControl.translatesAutoresizingMaskIntoConstraints = false
            self.categoryTypeSegmentControl.insertSegment(withTitle: "Expense", at: 0, animated: false)
            self.categoryTypeSegmentControl.insertSegment(withTitle: "Income", at: 1, animated: false)
            if selectedCategory == CategoryType.expense {
                self.categoryTypeSegmentControl.selectedSegmentIndex = 0
            } else {
                self.categoryTypeSegmentControl.selectedSegmentIndex = 1
            }
            
            
            staticCell.addSubview(self.categoryTypeSegmentControl)
            NSLayoutConstraint.activate([
                self.categoryTypeSegmentControl.trailingAnchor.constraint(equalTo: staticCell.trailingAnchor, constant: -15),
                self.categoryTypeSegmentControl.centerYAnchor.constraint(equalTo: staticCell.centerYAnchor)
            ])
        }
        
        return staticCell
    }
    
    
}

protocol CategoryAddDelegate {
    func categoryUpdate()
}
