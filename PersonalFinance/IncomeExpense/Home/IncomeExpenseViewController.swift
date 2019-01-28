//
//  IncomeExpenseViewController.swift
//  PersonalFinance
//
//  Created by Daniel Gunawan on 11/12/18.
//  Copyright © 2018 Daniel Gunawan. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class IncomeExpenseViewController: UIViewController, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource {
   
    
    let financeManager = FinanceManager.shared
    let transactionFecthControler = FinanceManager.shared.getExpenseResultController(fromDate: nil, toDate: nil)
    var collectionView  : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        var cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: 80, height: 80), collectionViewLayout: layout)
        return cv
    }()
    
    let arrayTemp : [String] = ["food", "transport", "parking","movies","internet","more"]
    let tableLatestExpenses : UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "Cash Quest"
        self.collectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "categoryCell")
        
        UICostum()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.tableLatestExpenses.delegate = self
        self.tableLatestExpenses.dataSource = self
        tableLatestExpenses.register(LatestExpensesTVC.self, forCellReuseIdentifier: "latestCell")
        tableLatestExpenses.reloadData()
       
        do {
            try transactionFecthControler.performFetch()
        } catch  {
            print( "error : \(error.localizedDescription)")
        }
        transactionFecthControler.delegate = self
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(transactionFecthControler.fetchedObjects?.count)
        return transactionFecthControler.fetchedObjects?.count ?? 0
        
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "latestCell", for: indexPath) as! LatestExpensesTVC
        if let transaction = transactionFecthControler.fetchedObjects?[indexPath.row] {
                            cell.trasactionNameLabel.text = transaction.desc
                            cell.transactionAmountLabel.text = "\(transaction.amount)"
        }
      return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func UICostum()  {
        //navigation bar
        
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.3568627451, green: 0.5921568627, blue: 0.8392156863, alpha: 1)
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.3568627451, green: 0.5921568627, blue: 0.8392156863, alpha: 1)
        navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.3568627451, green: 0.5921568627, blue: 0.8392156863, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        //createComponen
        let savingLabel     : UILabel   = UILabel()
        let viewBudget      : UIView    = UIView()
        let amountBudget    : UILabel   = UILabel()
        let budgetLabel     : UILabel   = UILabel()
        let warninglLabel   : UILabel   = UILabel()
        let headerCollectionLabel : UILabel = UILabel()
        let viewContainerTabel : UIView = UIView()
        let headerTableExpenses : UILabel = UILabel()
       
        //add componen to view
        view.addSubview(savingLabel)
        view.addSubview(viewBudget)
        view.addSubview(amountBudget)
        view.addSubview(budgetLabel)
        view.addSubview(warninglLabel)
        view.addSubview(collectionView)
        collectionView.addSubview(headerCollectionLabel)
        view.addSubview(viewContainerTabel)
        viewContainerTabel.addSubview(headerTableExpenses)
        viewContainerTabel.addSubview(tableLatestExpenses)
        
        
        
        
        //Saving Label
        savingLabel.translatesAutoresizingMaskIntoConstraints = false
        savingLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive                            = true
        savingLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive                          = true
        savingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive                     = true
        savingLabel.heightAnchor.constraint(equalToConstant: (navigationController?.navigationBar.frame.height)! + 10).isActive  = true
        savingLabel.text            = "Savings : Rp 4.000.000"
        savingLabel.textAlignment   = .center
        savingLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        savingLabel.font = UIFont(name: "Futura", size: 20)
    
        //view budget
        viewBudget.translatesAutoresizingMaskIntoConstraints = false
        viewBudget.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive    = true
        viewBudget.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive  = true
        viewBudget.topAnchor.constraint(equalTo: savingLabel.bottomAnchor, constant: 10).isActive       = true
        viewBudget.heightAnchor.constraint(equalToConstant: view.frame.height/5).isActive               = true
        viewBudget.backgroundColor = #colorLiteral(red: 0.2941176471, green: 0.7176470588, blue: 0.4666666667, alpha: 1)
        let heightViewBudget = view.frame.height/4
        
        //Amount Label
        budgetLabel.translatesAutoresizingMaskIntoConstraints = false
        budgetLabel.leadingAnchor.constraint(equalTo: viewBudget.leadingAnchor).isActive        = true
        budgetLabel.trailingAnchor.constraint(equalTo: viewBudget.trailingAnchor).isActive      = true
        budgetLabel.bottomAnchor.constraint(equalTo: amountBudget.topAnchor).isActive           = true
        budgetLabel.heightAnchor.constraint(equalToConstant: heightViewBudget/5).isActive       = true
        budgetLabel.text = "Budget Remaining"
        budgetLabel.textAlignment = .center
        budgetLabel.font = UIFont(name: "Futura", size: 20)
        budgetLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        print(view.frame.height/4)
        
        //budget Label
        amountBudget.translatesAutoresizingMaskIntoConstraints = false
        amountBudget.leadingAnchor.constraint(equalTo: viewBudget.leadingAnchor).isActive           = true
        amountBudget.trailingAnchor.constraint(equalTo: viewBudget.trailingAnchor).isActive         = true
        amountBudget.centerYAnchor.constraint(equalTo: viewBudget.centerYAnchor).isActive           = true
        amountBudget.centerXAnchor.constraint(equalTo: viewBudget.centerXAnchor).isActive           = true
        amountBudget.heightAnchor.constraint(equalToConstant: heightViewBudget/3).isActive          = true
        amountBudget.text           = "Rp 80.000.000"
        amountBudget.textAlignment = .center
        amountBudget.font = UIFont(name: "Futura", size: 30)
        amountBudget.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        print("lewat ini ngk")
        
        //warning Label
        warninglLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            warninglLabel.leadingAnchor.constraint(equalTo: viewBudget.leadingAnchor),
            warninglLabel.trailingAnchor.constraint(equalTo: viewBudget.trailingAnchor),
            warninglLabel.topAnchor.constraint(equalTo: amountBudget.bottomAnchor),
            warninglLabel.bottomAnchor.constraint(equalTo: viewBudget.bottomAnchor, constant : -10)
        ])
        warninglLabel.text           = "Doing Great!"
        warninglLabel.textAlignment = .center
        print("lewat ini ngk")
        warninglLabel.font = UIFont(name: "Futura", size: 20)
        warninglLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        
        //collectin view
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        collectionView.heightAnchor.constraint(equalToConstant: view.frame.height / 4).isActive = true
        collectionView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive    = true
        collectionView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive  = true
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: viewBudget.bottomAnchor, constant: 10).isActive = true
        print("Ini width = \(view.frame.width)")
        print("ini height = \(view.frame.height/4)")
        
  
        //view container tabel expenses
        viewContainerTabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewContainerTabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 15),
            viewContainerTabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant : 10),
            viewContainerTabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant : -10),
            viewContainerTabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant : -10),
            
            ])
        viewContainerTabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
       
        viewContainerTabel.clipsToBounds = true
        viewContainerTabel.layer.shadowColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        viewContainerTabel.layer.shadowOpacity = 1
        viewContainerTabel.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        //header Category
        headerCollectionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerCollectionLabel.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor, constant: 30 ),
            headerCollectionLabel.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            headerCollectionLabel.topAnchor.constraint(equalTo: collectionView.topAnchor)
            ])
       
        headerCollectionLabel.font = UIFont(name: "Futura", size: 15)
        headerCollectionLabel.text = "Add Record"
        headerCollectionLabel.textAlignment = .left
        
        
        //headerTabelExpense
        headerTableExpenses.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerTableExpenses.leadingAnchor.constraint(equalTo: viewContainerTabel.layoutMarginsGuide.leadingAnchor, constant : 10),
            headerTableExpenses.trailingAnchor.constraint(equalTo: viewContainerTabel.layoutMarginsGuide.trailingAnchor),
            headerTableExpenses.topAnchor.constraint(equalTo: viewContainerTabel.topAnchor)
            ])
        headerTableExpenses.font = UIFont(name: "Futura", size: 15)
        headerTableExpenses.textAlignment = .left
        headerTableExpenses.text = "Latest Expenses"
       
        //tabel latest expenses
        tableLatestExpenses.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableLatestExpenses.topAnchor.constraint(equalTo: headerTableExpenses.bottomAnchor, constant: 5),
            tableLatestExpenses.leadingAnchor.constraint(equalTo: viewContainerTabel.leadingAnchor),
            tableLatestExpenses.trailingAnchor.constraint(equalTo: viewContainerTabel.trailingAnchor),
            tableLatestExpenses.bottomAnchor.constraint(equalTo: viewContainerTabel.bottomAnchor),
            tableLatestExpenses.widthAnchor.constraint(equalTo: viewContainerTabel.widthAnchor)
            ])
        
        tableLatestExpenses.separatorStyle = .none
        print("Ini width table : \(tableLatestExpenses.frame.width)")

        //
    }
}


extension IncomeExpenseViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCollectionViewCell
        cell.layer.borderColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
        cell.layer.borderWidth = 1
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 15
        cell.categoryNameLabel.font = UIFont(name: "Futura", size: 12)
        cell.categoryNameLabel.text = arrayTemp[indexPath.row]
        cell.categoryView.image = UIImage(named: "\(arrayTemp[indexPath.row])")
    
        return cell
    }
}

extension IncomeExpenseViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,insetForSectionAt section: Int) -> UIEdgeInsets {
        let sectionLeft = (collectionView.frame.width - (3 * 80)) / 4
        print(" ini section left = \(sectionLeft)")
        let section = UIEdgeInsets(top: collectionView.frame.height/14 + 10, left: sectionLeft, bottom: collectionView.frame.height/14 - 10, right: sectionLeft)
        return section
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let sections = ((collectionView.frame.width - (3 * 80)) / 4)
        
        return sections
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row != 5 {
        let vc =  storyboard?.instantiateViewController(withIdentifier: "addrecord") as? AddRecordViewController
        vc?.category = arrayTemp[indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
}

extension IncomeExpenseViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableLatestExpenses.reloadData()
    }
}

