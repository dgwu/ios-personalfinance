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



class IncomeExpenseViewController: UIViewController {
   
    
    let financeManager = FinanceManager.shared
    let transactionFecthControler = FinanceManager.shared.getExpenseResultController(fromDate: nil, toDate: nil, take: 10)
    var collectionView  : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        var cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: 80, height: 80), collectionViewLayout: layout)
        
        return cv
    }()
//    let slider : CQSlider = CQSlider()
    let tableLatestExpenses : UITableView = UITableView()
    var getCategory: [Category]?
    var selectCategory : Category?
    var selectTransaction : Transaction?
    let currency = SetupManager.shared
    lazy var PresentationDelegate = PresentationManager()
    var budgetAmountLabel: UILabel!
    var great : Double!
    var ok : Double!
    var worst : Double!
    var statusValue : CGFloat = CGFloat()
    let viewBudget      : UIView    = UIView()
    var widthStatusBar : CGFloat = CGFloat()
    var status : Int = 0
    let backGroundView : UIView = UIView()
    let statusBar : UIView = UIView()
    
    @IBOutlet weak var viewCustumPopUp: UIView!
    @IBOutlet weak var headerPopUp: UILabel!
    @IBOutlet weak var containerViewPopUp: UIView!
    @IBOutlet weak var dateLabel: UITextField!
    @IBOutlet weak var nameLabelExpense: UITextField!
    @IBOutlet weak var amountLabel: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var bottomContraint: NSLayoutConstraint!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !SetupManager.shared.isExpenseCategoriesPreloaded {
            // add delay to make sure preloaded category are loaded in view
            sleep(1)
        }
        
        getCategory = FinanceManager.shared.categoryList(type: .expense)
        transactionFecthControler.delegate = self
        do {
            try transactionFecthControler.performFetch()
        } catch  {
            print( "error : \(error.localizedDescription)")
        }
        InitialSetup()
        print("height coll :\(collectionView.frame.height)")
     
    }

    override func viewWillAppear(_ animated: Bool) {
        status = 0
        collectionView.reloadData()
        tableLatestExpenses.reloadData()
        self.budgetAmountLabel.text = GeneralHelper.displayAmount(amount: financeManager.monthlyRemainingBudget())
        self.statusBarFunc()
    }
    
    func InitialSetup()   {
        self.navigationController?.navigationBar.topItem?.title = "Cash Quest"
        self.collectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "categoryCell")
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.tableLatestExpenses.delegate = self
        self.tableLatestExpenses.dataSource = self
        
        tableLatestExpenses.register(LatestExpensesTVC.self, forCellReuseIdentifier: "latestCell")
        tableLatestExpenses.reloadData()
        UICostum()
        statusBarFunc()
        view.layoutIfNeeded()
        
    }
    
    func statusBarFunc() {
        great = financeManager.monthlyBudgetMeter().great
        ok = financeManager.monthlyBudgetMeter().ok
        worst = financeManager.monthlyBudgetMeter().worst
        print("bzz ini nilai dailybudgetmeter \(financeManager.monthlyBudgetMeter())")
        
        statusValue = CGFloat(financeManager.monthlyRemainingBudget())
        widthStatusBar = ((statusValue-CGFloat(worst)) / CGFloat(great-worst) ) * backGroundView.frame.width
        
        print("bzz back : \(backGroundView.frame.width)")
        print("bzz widthStatusBar : \(widthStatusBar)")
       
        
        widthStatusBar = widthStatusBar < 10 ? 10 : widthStatusBar
//        self.statusBar.widthAnchor.constraint(equalToConstant: widthStatusBar).isActive = true
//        statusBar.frame.size.width = widthStatusBar
        self.statusBar.backgroundColor = getBarStatusColor(value: widthStatusBar, maxValue: backGroundView.frame.width)
        statusBar.frame = CGRect(x: 0, y: 0, width: widthStatusBar, height: 16)
        
        print(Float(financeManager.transactionSummaryInPeriod(fromDate: Date().startOfMonth(),  toDate: Date()).totalExpense))
         print("bzz width statusbar :\(statusBar.frame.width)")
    }
    
    func getBarStatusColor (value: CGFloat, maxValue: CGFloat) -> UIColor {
        let redR : CGFloat = 255
        let redG : CGFloat = 77
        let redB : CGFloat = 77
        
        let yellowR : CGFloat = 255
        let yellowG : CGFloat = 246
        let yellowB : CGFloat = 99
        
        let greenR : CGFloat = 31
        let greenG : CGFloat = 222
        let greenB : CGFloat = 42
        
        var newColorR : CGFloat?
        var newColorG : CGFloat?
        var newColorB : CGFloat?
        
        if value / maxValue < 0.5 {
            newColorR = redR // soalnya redR & yellowR nilainya sama
            newColorG = redG + ((yellowG - redG) * CGFloat(value / maxValue))
            newColorB = redB + ((yellowB - redB) * CGFloat(value / maxValue))
        } else {
            newColorR = yellowR + ((greenR - yellowR) * CGFloat(value / maxValue))
            newColorG = yellowG + ((greenG - yellowG) * CGFloat(value / maxValue))
            newColorB = yellowB + ((greenB - yellowB) * CGFloat(value / maxValue))
        }
        
//        return UIColor(red: newColorR!, green: newColorG!, blue: newColorB!, alpha: 1)
        return UIColor(red: newColorR!/255, green: newColorG!/255, blue: newColorB!/255, alpha: 1)
    }
    
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==  "goToCardViewRecord" {
            let cell = segue.destination as! CardViewRecordVC
            cell.transitioningDelegate = PresentationDelegate
            cell.modalPresentationStyle = .custom
            if status == 0 {
                print("Status 0")
                cell.categorySelected = selectCategory
                cell.statusTemp = status
            }else{
                cell.categorySelected = selectCategory
                cell.transactionSelected = selectTransaction
                cell.statusTemp = status
                print("status = 1")
               
            }
        }
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
       
        let viewBudgetSection : UIView = UIView()
        budgetAmountLabel = UILabel()
        let budgetLabel     : UILabel   = UILabel()
        let headerCollectionLabel : UILabel = UILabel()
        let viewContainerTabel : UIView = UIView()
        let headerTableExpenses : UILabel = UILabel()
        
        let worseLable : UILabel = UILabel()
        let okLabel : UILabel = UILabel()
        let greatLable : UILabel = UILabel()
       
        
       
        //add componen to view
        view.addSubview(viewBudget)
        viewBudget.addSubview(viewBudgetSection)
        viewBudgetSection.addSubview(budgetLabel)
        viewBudgetSection.addSubview(budgetAmountLabel)
        view.addSubview(collectionView)
        view.addSubview(headerCollectionLabel)
        view.addSubview(viewContainerTabel)
        viewContainerTabel.addSubview(headerTableExpenses)
        viewContainerTabel.addSubview(tableLatestExpenses)
        
        viewBudget.addSubview(worseLable)
        viewBudget.addSubview(okLabel)
        viewBudget.addSubview(greatLable)
        viewBudget.addSubview(backGroundView)
        backGroundView.addSubview(statusBar)
      
        
        //view budget
        viewBudget.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewBudget.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            viewBudget.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            viewBudget.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            viewBudget.heightAnchor.constraint(equalToConstant: view.frame.height/8)
            ])
        viewBudget.backgroundColor = UIColor.clear
        viewBudget.layer.borderWidth = 2
        viewBudget.layer.borderColor = #colorLiteral(red: 0.258031249, green: 0.623462081, blue: 0.4137890041, alpha: 1)
        viewBudget.clipsToBounds = true
        viewBudget.layer.cornerRadius  = 5
        viewBudget.layoutIfNeeded()
        print("height view budget : \(viewBudget.frame.height)")
        //View budget section
        viewBudgetSection.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewBudgetSection.topAnchor.constraint(equalTo: viewBudget.topAnchor),
            viewBudgetSection.leadingAnchor.constraint(equalTo: viewBudget.leadingAnchor),
            viewBudgetSection.trailingAnchor.constraint(equalTo: viewBudget.trailingAnchor),
            viewBudgetSection.heightAnchor.constraint(equalToConstant: (view.frame.height/8)/4)
            ])
        viewBudgetSection.clipsToBounds = true
        viewBudgetSection.backgroundColor = #colorLiteral(red: 0.258031249, green: 0.623462081, blue: 0.4137890041, alpha: 1)
        print("Height view section :\(viewBudgetSection.frame.size.height)")
        let heightViewbudget = (view.frame.height/8)
        //budget Label
        budgetLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            budgetLabel.leftAnchor.constraint(equalTo: viewBudgetSection.leftAnchor, constant : 10),
            budgetLabel.topAnchor.constraint(equalTo: viewBudgetSection.topAnchor),
            budgetLabel.bottomAnchor.constraint(equalTo: viewBudgetSection.bottomAnchor)
            ])
        budgetLabel.text = "Budget Remaining"
        budgetLabel.textAlignment = .left
        budgetLabel.font = UIFont(name: "SF Pro Text", size: 16)
        budgetLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        //amount Label
        budgetAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            budgetAmountLabel.trailingAnchor.constraint(equalTo: viewBudgetSection.trailingAnchor, constant: -10),
            budgetAmountLabel.leadingAnchor.constraint(equalTo: budgetLabel.trailingAnchor, constant: 10),
            budgetAmountLabel.topAnchor.constraint(equalTo: viewBudgetSection.topAnchor),
            budgetAmountLabel.bottomAnchor.constraint(equalTo: viewBudgetSection.bottomAnchor)
        ])
        let budget = financeManager.monthlyRemainingBudget()
        budgetAmountLabel.text = GeneralHelper.displayAmount(amount: budget)
        budgetAmountLabel.textAlignment = .right
        budgetAmountLabel.font = UIFont(name: "SF Pro Text", size: 16)
        budgetAmountLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        //backGroundView
       
        backGroundView.translatesAutoresizingMaskIntoConstraints =  false
        NSLayoutConstraint.activate([
            backGroundView.topAnchor.constraint(equalTo: greatLable.bottomAnchor, constant: 15),
            backGroundView.leadingAnchor.constraint(equalTo: viewBudget.leadingAnchor, constant: 20),
            backGroundView.trailingAnchor.constraint(equalTo: viewBudget.trailingAnchor, constant: -20),
            backGroundView.heightAnchor.constraint(equalToConstant: 16)
            ])
        
        backGroundView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        backGroundView.layoutIfNeeded()
        backGroundView.clipsToBounds = true
        backGroundView.layer.cornerRadius = backGroundView.frame.height/2

        //statusbar
        statusBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusBar.topAnchor.constraint(equalTo: backGroundView.topAnchor),
            statusBar.leadingAnchor.constraint(equalTo: backGroundView.leadingAnchor),
            statusBar.heightAnchor.constraint(equalToConstant: 16)
            ])

        statusBar.layoutIfNeeded()
        statusBar.clipsToBounds = true
        statusBar.layer.cornerRadius = statusBar.frame.height/2
        
        //label slider
        okLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            okLabel.topAnchor.constraint(equalTo: viewBudgetSection.bottomAnchor, constant :heightViewbudget * 0.1),
            okLabel.centerXAnchor.constraint(equalTo: viewBudget.centerXAnchor)
            ])
        okLabel.text = "Ok"
        okLabel.textAlignment = .center
        okLabel.font = UIFont(name: "SF Pro Text", size: 14)
        okLabel.textColor = UIColor.darkGray
        
        greatLable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            greatLable.topAnchor.constraint(equalTo: viewBudgetSection.bottomAnchor, constant :heightViewbudget * 0.1),
            greatLable.trailingAnchor.constraint(equalTo: viewBudget.trailingAnchor, constant : -20)
            ])
        greatLable.text = "Fine"
        greatLable.textAlignment = .right
        greatLable.font = UIFont(name: "SF Pro Text", size: 14)
        greatLable.textColor = UIColor.darkGray
        
        worseLable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            worseLable.topAnchor.constraint(equalTo: viewBudgetSection.bottomAnchor, constant :heightViewbudget * 0.1),
            worseLable.leadingAnchor.constraint(equalTo: viewBudget.leadingAnchor, constant : 20)
            ])
        worseLable.text = "Overspent"
        worseLable.textAlignment = .left
        worseLable.font = UIFont(name: "SF Pro Text", size: 14)
        worseLable.textColor = UIColor.darkGray
        
        //collection view
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.36),
            collectionView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),
            collectionView.topAnchor.constraint(equalTo: headerCollectionLabel.bottomAnchor, constant : 5)
            ])
        collectionView.isScrollEnabled = false
        collectionView.layoutIfNeeded()
        print("Height collectionView frame :\(collectionView.frame)")

        //view container tabel expenses
        viewContainerTabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewContainerTabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 5),
            viewContainerTabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant : 10),
            viewContainerTabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant : -10),
            viewContainerTabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant : -10),
            
            ])
        viewContainerTabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        viewContainerTabel.clipsToBounds = true
        viewContainerTabel.layer.borderWidth = 0.5
        viewContainerTabel.layer.cornerRadius = 5
        viewContainerTabel.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
       
        //header Category
        headerCollectionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerCollectionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant : 20  ),
            headerCollectionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            headerCollectionLabel.topAnchor.constraint(equalTo: viewBudget.bottomAnchor, constant : 20 ),
            ])
        headerCollectionLabel.font = UIFont(name: "SF Pro Text", size: 15)
        headerCollectionLabel.text = "Add Record"
        headerCollectionLabel.textAlignment = .left
    
        //headerTabelExpense
        headerTableExpenses.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerTableExpenses.leadingAnchor.constraint(equalTo: viewContainerTabel.safeAreaLayoutGuide.leadingAnchor),
            headerTableExpenses.trailingAnchor.constraint(equalTo: viewContainerTabel.safeAreaLayoutGuide.trailingAnchor),
            headerTableExpenses.topAnchor.constraint(equalTo: viewContainerTabel.topAnchor ),
            headerTableExpenses.heightAnchor.constraint(equalToConstant: (view.frame.height/8)/3)
            ])
   
        headerTableExpenses.font = UIFont(name: "SF Pro Text", size: 15)
        headerTableExpenses.textAlignment = .left
        headerTableExpenses.text = "    Latest Expenses"
        headerTableExpenses.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        headerTableExpenses.layoutIfNeeded()
        
        //tabel latest expenses
        tableLatestExpenses.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableLatestExpenses.topAnchor.constraint(equalTo: headerTableExpenses.bottomAnchor),
            tableLatestExpenses.leadingAnchor.constraint(equalTo: viewContainerTabel.leadingAnchor),
            tableLatestExpenses.trailingAnchor.constraint(equalTo: viewContainerTabel.trailingAnchor),
            tableLatestExpenses.bottomAnchor.constraint(equalTo: viewContainerTabel.bottomAnchor),
            tableLatestExpenses.widthAnchor.constraint(equalTo: viewContainerTabel.widthAnchor)
            ])
    }
}


extension IncomeExpenseViewController: UICollectionViewDataSource {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getCategory?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCollectionViewCell
        cell.containerImage.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        cell.containerImage.layer.borderWidth = 1
        cell.containerImage.clipsToBounds = true
        cell.containerImage.layer.cornerRadius = 10
        cell.categoryNameLabel.text = getCategory![indexPath.row].desc
        guard let category = getCategory?[indexPath.row].iconName else {
            print("error")
            return cell
        }
        cell.categoryView.image = UIImage(named: "\(category)")

        return cell
    }
}


extension IncomeExpenseViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width * 0.8 / 4
        let height = collectionView.frame.height / 3
        
        return CGSize(width: width , height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let width = ( collectionView.frame.width - (collectionView.frame.width * 0.8) )/4
        
        return width
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        status = 0
        selectCategory = getCategory![indexPath.row]
        performSegue(withIdentifier: "goToCardViewRecord", sender: self)
    }
}

extension IncomeExpenseViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableLatestExpenses.reloadData()
        self.getCategory = FinanceManager.shared.categoryList(type: .expense)
        self.budgetAmountLabel.text = GeneralHelper.displayAmount(amount: financeManager.monthlyRemainingBudget())
        self.statusBarFunc()
        self.collectionView.reloadData()
        print("bzz budi lagi")
    }
}

extension IncomeExpenseViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("fetchedObject")
        return transactionFecthControler.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        status = 1
        let index = indexPath.row
        print("---- \(index)")
        selectTransaction = transactionFecthControler.fetchedObjects?[index]
        selectCategory = selectTransaction?.category
        performSegue(withIdentifier: "goToCardViewRecord", sender: self)
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "latestCell", for: indexPath) as! LatestExpensesTVC
        if let transaction = transactionFecthControler.fetchedObjects?[indexPath.row] {
            
            if transaction.desc != "-" {
                // note from dg, mestinya transactionNameLabel, kurang N
                cell.trasactionNameLabel.text = transaction.desc
                cell.trasactionNameLabel.font = UIFont.systemFont(ofSize: cell.trasactionNameLabel.font.pointSize)
                cell.trasactionNameLabel.alpha = 1
            } else {
                cell.trasactionNameLabel.text = transaction.category?.desc
                cell.trasactionNameLabel.font = UIFont.italicSystemFont(ofSize: cell.trasactionNameLabel.font.pointSize)
                cell.trasactionNameLabel.alpha = 0.3
            }
            
            cell.transactionAmountLabel.text = GeneralHelper.displayAmount(amount: transaction.amount)
            guard let category = transaction.category?.iconName else {
                return cell
            }
            cell.categoryImage.image = UIImage(named: "\(category)")
        }
        cell.isUserInteractionEnabled = true

        print()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }

    
}



