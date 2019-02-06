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
    let slider : UISlider = UISlider()
    
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
        let viewBudgetSection : UIView = UIView()
        budgetAmountLabel = UILabel()
        let budgetLabel     : UILabel   = UILabel()
        let headerCollectionLabel : UILabel = UILabel()
        let viewContainerTabel : UIView = UIView()
        let headerTableExpenses : UILabel = UILabel()
        
        let worseLable : UILabel = UILabel()
        let okLabel : UILabel = UILabel()
        let greatLable : UILabel = UILabel()
        let worseAmountLable : UILabel = UILabel()
        let okAmountLable : UILabel = UILabel()
        let greatAmountLable : UILabel = UILabel()
        
        //add componen to view
        view.addSubview(viewBudget)
        viewBudget.addSubview(viewBudgetSection)
        viewBudgetSection.addSubview(budgetLabel)
        viewBudgetSection.addSubview(budgetAmountLabel)
        viewBudget.addSubview(slider)
        view.addSubview(collectionView)
        view.addSubview(headerCollectionLabel)
        view.addSubview(viewContainerTabel)
        viewContainerTabel.addSubview(headerTableExpenses)
        viewContainerTabel.addSubview(tableLatestExpenses)
        
        viewBudget.addSubview(worseLable)
        viewBudget.addSubview(okLabel)
        viewBudget.addSubview(greatLable)
        viewBudget.addSubview(worseAmountLable)
        viewBudget.addSubview(okAmountLable)
        viewBudget.addSubview(greatAmountLable)
        
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
        
        //View budget section
        viewBudgetSection.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewBudgetSection.topAnchor.constraint(equalTo: viewBudget.topAnchor),
            viewBudgetSection.leadingAnchor.constraint(equalTo: viewBudget.leadingAnchor),
            viewBudgetSection.trailingAnchor.constraint(equalTo: viewBudget.trailingAnchor),
            viewBudgetSection.heightAnchor.constraint(equalToConstant: (view.frame.height/8)/3)
            ])
        viewBudgetSection.clipsToBounds = true
        viewBudgetSection.backgroundColor = #colorLiteral(red: 0.258031249, green: 0.623462081, blue: 0.4137890041, alpha: 1)
        print("Height view section :\(viewBudgetSection.frame.size.height)")
        
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
        
        //slider budger
        slider.translatesAutoresizingMaskIntoConstraints =  false
        NSLayoutConstraint.activate([
            slider.topAnchor.constraint(equalTo: viewBudgetSection.bottomAnchor, constant: 30),
            slider.leadingAnchor.constraint(equalTo: viewBudget.leadingAnchor, constant: 20),
            slider.trailingAnchor.constraint(equalTo: viewBudget.trailingAnchor, constant: -20),
            slider.bottomAnchor.constraint(equalTo: viewBudget.bottomAnchor, constant: -30)
            ])
            slider.tintColor = UIColor.gray
            slider.value = slider.maximumValue
            slider.thumbTintColor = UIColor.gray
            print("\(slider.frame.height)")
        //label slider
        okLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            okLabel.topAnchor.constraint(equalTo: viewBudgetSection.bottomAnchor, constant: 5),
            okLabel.centerXAnchor.constraint(equalTo: viewBudget.centerXAnchor)
            ])
        okLabel.text = "OK"
        okLabel.textAlignment = .center
        okLabel.font = UIFont(name: "SF Pro Text", size: 12)
        okLabel.textColor = UIColor.white
        
        greatLable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            greatLable.topAnchor.constraint(equalTo: viewBudgetSection.bottomAnchor, constant: 5),
            greatLable.trailingAnchor.constraint(equalTo: viewBudget.trailingAnchor, constant : -20)
            ])
        greatLable.text = "GREAT"
        greatLable.textAlignment = .right
        greatLable.font = UIFont(name: "SF Pro Text", size: 12)
        greatLable.textColor = UIColor.white
        
        worseLable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            worseLable.topAnchor.constraint(equalTo: viewBudgetSection.bottomAnchor, constant: 5),
            worseLable.leadingAnchor.constraint(equalTo: viewBudget.leadingAnchor, constant : 20)
            ])
        worseLable.text = "WORSE"
        worseLable.textAlignment = .left
        worseLable.font = UIFont(name: "SF Pro Text", size: 12)
        worseLable.textColor = UIColor.white
        
        okAmountLable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            okAmountLable.bottomAnchor.constraint(equalTo: viewBudget.bottomAnchor, constant: -5),
            okAmountLable.centerXAnchor.constraint(equalTo: viewBudget.centerXAnchor)
            ])
        okAmountLable.text = "500K"
        okAmountLable.textAlignment = .center
        okAmountLable.font = UIFont(name: "SF Pro Text", size: 12)
        okAmountLable.textColor = UIColor.white
        
        greatAmountLable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            greatAmountLable.bottomAnchor.constraint(equalTo: viewBudget.bottomAnchor, constant: -5),
            greatAmountLable.trailingAnchor.constraint(equalTo: viewBudget.trailingAnchor, constant: -20)
            ])
        greatAmountLable.text = "1000K"
        greatAmountLable.textAlignment = .right
        greatAmountLable.font = UIFont(name: "SF Pro Text", size: 12)
        greatAmountLable.textColor = UIColor.white
        
        worseAmountLable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            worseAmountLable.bottomAnchor.constraint(equalTo: viewBudget.bottomAnchor, constant: -5),
            worseAmountLable.leadingAnchor.constraint(equalTo: viewBudget.leadingAnchor, constant: 20)
            ])
        worseAmountLable.text = "25K"
        worseAmountLable.textAlignment = .left
        worseAmountLable.font = UIFont(name: "SF Pro Text", size: 12)
        worseAmountLable.textColor = UIColor.white
        
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






