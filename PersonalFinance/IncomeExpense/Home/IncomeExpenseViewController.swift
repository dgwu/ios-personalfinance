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
    
    let tableLatestExpenses : UITableView = UITableView()
    var getCategory: [Category]?
    var selectCategory : Category?
    let currency = SetupManager.shared
    lazy var PresentationDelegate = PresentationManager()
    @IBOutlet weak var viewCustumPopUp: UIView!
    @IBOutlet weak var headerPopUp: UILabel!
    @IBOutlet weak var containerViewPopUp: UIView!
    @IBOutlet weak var dateLabel: UITextField!
    @IBOutlet weak var nameLabelExpense: UITextField!
    @IBOutlet weak var amountLabel: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var bottomContraint: NSLayoutConstraint!
    
    var budgetAmountLabel: UILabel!
    
    
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
        collectionView.reloadData()
        tableLatestExpenses.reloadData()
        self.budgetAmountLabel.text = GeneralHelper.displayAmount(amount: financeManager.monthlyRemainingBudget())
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
         view.layoutIfNeeded()
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
        let viewBudget      : UIView    = UIView()
        budgetAmountLabel = UILabel()
        let budgetLabel     : UILabel   = UILabel()
        let warninglLabel   : UILabel   = UILabel()
        let headerCollectionLabel : UILabel = UILabel()
        let viewContainerTabel : UIView = UIView()
        let headerTableExpenses : UILabel = UILabel()
       
        //add componen to view
        view.addSubview(viewBudget)
        viewBudget.addSubview(budgetAmountLabel)
        viewBudget.addSubview(budgetLabel)
        viewBudget.addSubview(warninglLabel)
        view.addSubview(collectionView)
        view.addSubview(headerCollectionLabel)
        view.addSubview(viewContainerTabel)
        viewContainerTabel.addSubview(headerTableExpenses)
        viewContainerTabel.addSubview(tableLatestExpenses)
 
        
        //view budget
        viewBudget.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewBudget.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            viewBudget.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            viewBudget.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            viewBudget.heightAnchor.constraint(equalToConstant: view.frame.height/8)
            ])
        viewBudget.backgroundColor = #colorLiteral(red: 0.2941176471, green: 0.7176470588, blue: 0.4666666667, alpha: 1)
        viewBudget.clipsToBounds = true
        viewBudget.layer.cornerRadius  = 5
        
        //budget Label
        budgetLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            budgetLabel.leftAnchor.constraint(equalTo: viewBudget.leftAnchor, constant : 10),
            budgetLabel.topAnchor.constraint(equalTo: viewBudget.topAnchor, constant: 10),
//            budgetLabel.rightAnchor.constraint(equalTo: amountBudget.leftAnchor, constant: 10),
            budgetLabel.heightAnchor.constraint(equalTo: budgetLabel.heightAnchor)
            ])
        budgetLabel.text = "Budget Remaining"
        budgetLabel.textAlignment = .left
        budgetLabel.font = UIFont(name: "SF Pro Text", size: 16)
        budgetLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        //amount Label
        budgetAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            budgetAmountLabel.trailingAnchor.constraint(equalTo: viewBudget.trailingAnchor, constant: -10),
            budgetAmountLabel.leadingAnchor.constraint(equalTo: budgetLabel.trailingAnchor, constant: 10),
            budgetAmountLabel.topAnchor.constraint(equalTo: viewBudget.topAnchor, constant : 10),
        ])
        let budget = financeManager.monthlyRemainingBudget()
    
        budgetAmountLabel.text = GeneralHelper.displayAmount(amount: budget)
        budgetAmountLabel.textAlignment = .right
        budgetAmountLabel.font = UIFont(name: "SF Pro Text", size: 16)
        budgetAmountLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        //warning Label
        warninglLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            warninglLabel.leadingAnchor.constraint(equalTo: viewBudget.leadingAnchor),
            warninglLabel.trailingAnchor.constraint(equalTo: viewBudget.trailingAnchor),
            warninglLabel.bottomAnchor.constraint(equalTo: viewBudget.bottomAnchor, constant : -20),
            warninglLabel.centerXAnchor.constraint(equalTo: viewBudget.centerXAnchor)
        ])
        warninglLabel.text           = "Doing Great!"
        warninglLabel.textAlignment = .center
        warninglLabel.font = UIFont(name: "SF Pro Text", size: 35)
        warninglLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        
        //collection view
        collectionView.translatesAutoresizingMaskIntoConstraints = false
       
        collectionView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35),
            collectionView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),
            collectionView.topAnchor.constraint(equalTo: headerCollectionLabel.bottomAnchor)
            ])
        collectionView.layoutIfNeeded()
        print("Height collectionView frame :\(collectionView.frame)")
        
        //view container tabel expenses
        viewContainerTabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewContainerTabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
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
            headerCollectionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant : 30  ),
            headerCollectionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            headerCollectionLabel.topAnchor.constraint(equalTo: viewBudget.bottomAnchor, constant : 20 ),
            ])
        headerCollectionLabel.font = UIFont(name: "SF Pro Text", size: 15)
        headerCollectionLabel.text = "Add Record"
        headerCollectionLabel.textAlignment = .left
    
        //headerTabelExpense
        headerTableExpenses.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerTableExpenses.leadingAnchor.constraint(equalTo: viewContainerTabel.safeAreaLayoutGuide.leadingAnchor, constant : 15),
            headerTableExpenses.trailingAnchor.constraint(equalTo: viewContainerTabel.safeAreaLayoutGuide.trailingAnchor),
            headerTableExpenses.topAnchor.constraint(equalTo: viewContainerTabel.topAnchor, constant : 10 ),
            ])
        headerTableExpenses.font = UIFont(name: "SF Pro Text", size: 15)
        headerTableExpenses.textAlignment = .left
        headerTableExpenses.text = "Latest Expenses"
        
        //tabel latest expenses
        tableLatestExpenses.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableLatestExpenses.topAnchor.constraint(equalTo: headerTableExpenses.bottomAnchor, constant: 10),
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
    
//    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,insetForSectionAt section: Int) -> UIEdgeInsets {
//        let width = collectionView.frame.width * 0.8 / 4
//        let height = width + 20
//        let marginRightLeft = ( collectionView.frame.width - collectionView.frame.width * 0.8  )/8
//        let marginTopBottom = (collectionView.frame.height -  ( height * 3 )) / 6
//        print("1 = \(width)")
//        print("2 = \(marginRightLeft)")
//        print("3 = \(marginTopBottom)")
//        print("4 = \(collectionView.frame.width)")
//        print("6 = \(collectionView.frame.height)")
//        print("7 = \(height)")
//        print("\(collectionView.frame.height)")
//        let section = UIEdgeInsets(top: 0, left: marginRightLeft, bottom: 0, right: marginRightLeft)
//        return UIEdgeInsets.zero
//    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let width = ( collectionView.frame.width - (collectionView.frame.width * 0.8) )/4
        
        return width
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==  "goToCardViewRecord" {
            let cell = segue.destination as! CardViewRecordVC
            cell.categorySelected = selectCategory
            cell.transitioningDelegate = PresentationDelegate
            cell.modalPresentationStyle = .custom
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectCategory = getCategory![indexPath.row]
        let cell = CardViewRecordVC()
        cell.categorySelected = selectCategory
        performSegue(withIdentifier: "goToCardViewRecord", sender: self)
        
    }
}

extension IncomeExpenseViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableLatestExpenses.reloadData()
        self.getCategory = FinanceManager.shared.categoryList(type: .expense)
        self.budgetAmountLabel.text = GeneralHelper.displayAmount(amount: financeManager.monthlyRemainingBudget())
    }
}

extension IncomeExpenseViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("fetchedObject")
        return transactionFecthControler.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Asd")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "latestCell", for: indexPath) as! LatestExpensesTVC
        if let transaction = transactionFecthControler.fetchedObjects?[indexPath.row] {
           
            cell.trasactionNameLabel.text = transaction.desc
            cell.transactionAmountLabel.text = GeneralHelper.displayAmount(amount: transaction.amount)
            guard let category = transaction.category?.iconName else {
                return cell
            }
            cell.categoryImage.image = UIImage(named: "\(category)")
        }
        cell.isUserInteractionEnabled = false
        print()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    
    
}






