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
        layout.scrollDirection = .horizontal
        var cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: 80, height: 80), collectionViewLayout: layout)
        
        return cv
    }()
    
    let tableLatestExpenses : UITableView = UITableView()
    let getCategory = FinanceManager.shared.categoryList(type: .expense)
    var selectCategory : Category?
    let currency = SetupManager.shared
    
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
        
        do {
            try transactionFecthControler.performFetch()
        } catch  {
            print( "error : \(error.localizedDescription)")
        }
        transactionFecthControler.delegate = self
        InitialSetup()
        print("height coll :\(collectionView.frame.height)")
     
    }

    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData() 
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
        GetDate()
        PopUpRecordDisActice()
        view.bringSubviewToFront(viewCustumPopUp)
        view.bringSubviewToFront(containerViewPopUp)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        view.layoutIfNeeded()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.becomeFirstResponder()
        self.view.endEditing(true)
    }
    
    @IBAction func saveRecord(_ sender: Any) {
       PopUpRecordDisActice()
        InsertExpenses()
        nameLabelExpense.text = ""
        dateLabel.text = ""
        amountLabel.text = ""
        
        self.view.endEditing(true)
    }
    
    @IBAction func cancelRecord(_ sender: Any) {
        PopUpRecordDisActice()
        nameLabelExpense.text = ""
        dateLabel.text = ""
        amountLabel.text = ""
        self.view.endEditing(true)
    }
    
    let datePicker = UIDatePicker()
    func GetDate()  {
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.addTarget(self, action: #selector(self.DatePickerValue(sender:)), for: .valueChanged)
        
        if datePicker == datePicker {
            self.dateLabel.inputView = datePicker
            self.dateLabel.text = "Today"
        }else{
            self.dateLabel.inputView = datePicker
            
        }
        self.view.endEditing(true)
    }
    
    @objc func DatePickerValue(sender : UIDatePicker)   {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.long
        formatter.timeStyle = DateFormatter.Style.none
        self.dateLabel.text = formatter.string(from: datePicker.date)
    }

    func InsertExpenses()   {
        print("insert Expenses")
        let defaultWallet = FinanceManager.shared.defaultWallet()
        guard var expenseDesc = nameLabelExpense.text else {return}
        
        if expenseDesc.count < 1 {
            expenseDesc = "-"
        }
        
        FinanceManager.shared.insertExpense(date: datePicker.date, amount: (amountLabel.text! as NSString).doubleValue , category: selectCategory!, wallet: defaultWallet!, desc: expenseDesc)
        
    }

    func PopUpRecordActice() {
        UIView.animate(withDuration: 0.5, animations: {
            self.viewCustumPopUp.alpha = 0.5
            self.containerViewPopUp.alpha = 1
        }, completion: nil)
    }
    
    func PopUpRecordDisActice() {
        UIView.animate(withDuration: 0.5, animations: {
            self.viewCustumPopUp.alpha = 0
            self.containerViewPopUp.alpha = 0
        }, completion: nil)
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
        let amountBudget    : UILabel   = UILabel()
        let budgetLabel     : UILabel   = UILabel()
        let warninglLabel   : UILabel   = UILabel()
        let headerCollectionLabel : UILabel = UILabel()
        let viewContainerTabel : UIView = UIView()
        let headerTableExpenses : UILabel = UILabel()
       
        //add componen to view
        view.addSubview(viewBudget)
        viewBudget.addSubview(amountBudget)
        viewBudget.addSubview(budgetLabel)
        viewBudget.addSubview(warninglLabel)
        view.addSubview(collectionView)
        view.addSubview(headerCollectionLabel)
        view.addSubview(viewContainerTabel)
        viewContainerTabel.addSubview(headerTableExpenses)
        viewContainerTabel.addSubview(tableLatestExpenses)
 
        //popup custom
        containerViewPopUp.clipsToBounds = true
        containerViewPopUp.layer.cornerRadius = 10
        saveButton.layer.cornerRadius = 5
        cancelButton.layer.cornerRadius = 5
        
        //view budget
        viewBudget.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewBudget.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            viewBudget.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            viewBudget.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            viewBudget.heightAnchor.constraint(equalToConstant: view.frame.height/5)
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
        budgetLabel.font = UIFont(name: "Helvetica Neue", size: 14)
        budgetLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        //amount Label
        amountBudget.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            amountBudget.trailingAnchor.constraint(equalTo: viewBudget.trailingAnchor, constant: -10),
            amountBudget.leadingAnchor.constraint(equalTo: budgetLabel.trailingAnchor, constant: 10),
            amountBudget.topAnchor.constraint(equalTo: viewBudget.topAnchor, constant : 10),
        ])
        let budget = financeManager.monthlyRemainingBudget()
    
        amountBudget.text = "\(currency.userDefaultCurrency) \(budget)"
        amountBudget.textAlignment = .right
        amountBudget.font = UIFont(name: "Helvetica Neue", size: 14)
        amountBudget.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        //warning Label
        warninglLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            warninglLabel.leadingAnchor.constraint(equalTo: viewBudget.leadingAnchor),
            warninglLabel.trailingAnchor.constraint(equalTo: viewBudget.trailingAnchor),
            warninglLabel.centerXAnchor.constraint(equalTo: viewBudget.centerXAnchor),
            warninglLabel.centerYAnchor.constraint(equalTo: viewBudget.centerYAnchor)
        ])
        warninglLabel.text           = "Doing Great!"
        warninglLabel.textAlignment = .center
        warninglLabel.font = UIFont(name: "Helvetica Neue", size: 40)
        warninglLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        
        //collectin view
        collectionView.translatesAutoresizingMaskIntoConstraints = false
       
        collectionView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
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
       
        //header Category
        headerCollectionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerCollectionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor , constant : 30 ),
            headerCollectionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            headerCollectionLabel.topAnchor.constraint(equalTo: viewBudget.bottomAnchor, constant : 20 ),
            ])
        headerCollectionLabel.font = UIFont(name: "Helvetica Neue", size: 15)
        headerCollectionLabel.text = "Add Record"
        headerCollectionLabel.textAlignment = .left
    
        //headerTabelExpense
        headerTableExpenses.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerTableExpenses.leadingAnchor.constraint(equalTo: viewContainerTabel.safeAreaLayoutGuide.leadingAnchor),
            headerTableExpenses.trailingAnchor.constraint(equalTo: viewContainerTabel.safeAreaLayoutGuide.trailingAnchor),
            headerTableExpenses.topAnchor.constraint(equalTo: viewContainerTabel.topAnchor, constant : 10 ),
            ])
        headerTableExpenses.font = UIFont(name: "Helvetica Neue", size: 15)
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
        
        tableLatestExpenses.separatorStyle = .none
        
    }
}


extension IncomeExpenseViewController: UICollectionViewDataSource {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getCategory?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCollectionViewCell
        cell.layer.borderColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
        cell.layer.borderWidth = 1
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 15
        cell.categoryNameLabel.font = UIFont(name: "Helvetica Neue", size: 12)
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
        let width = collectionView.frame.height * 0.8 / 3
        return CGSize(width: width , height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,insetForSectionAt section: Int) -> UIEdgeInsets {
        let width = collectionView.frame.height * 0.8 / 3
        let marginRightLeft = ( collectionView.frame.width - ( width * 4 ))/8
        let marginTopBottom = (collectionView.frame.height -  ( width * 3 )) / 6
        print("\(width)")
        print("\(marginRightLeft)")
        print("\(marginTopBottom)")
        print("\(collectionView.frame.width)")
        print("\(collectionView.frame.height)")
        let section = UIEdgeInsets(top: marginTopBottom, left: marginRightLeft, bottom: marginTopBottom, right: marginRightLeft)
        return section
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let width = collectionView.frame.height * 0.8 / 3
        let sections = ( collectionView.frame.width - ( width * 4 ))/4
        
        return sections
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectCategory = getCategory![indexPath.row]
        PopUpRecordActice()
    }
}

extension IncomeExpenseViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableLatestExpenses.reloadData()
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
            cell.transactionAmountLabel.text = "\(transaction.amount)"
            guard let category = transaction.category?.iconName else {
                return cell
            }
            cell.categoryImage.image = UIImage(named: "\(category)")
        }
        print()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    
    
}






