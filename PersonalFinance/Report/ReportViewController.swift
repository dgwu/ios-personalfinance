//
//  ReportViewController.swift
//  PersonalFinance
//
//  Created by Denis Wibisono on 09/01/19.
//  Copyright © 2019 Daniel Gunawan. All rights reserved.
//

import UIKit
import CoreData

enum Page: Int {
    case categoryDetails = 1
    case reportDetails = 2
}

class ReportViewController: UIViewController {
    @IBOutlet weak var displayedMonth: UILabel!
    @IBOutlet weak var nextMonthButton: UIButton!
    @IBOutlet weak var prevMonthButton: UIButton!
    @IBOutlet weak var topExpensesTable: UITableView!
    @IBOutlet weak var noTransactionsLabel: UILabel!
    @IBOutlet weak var noTransactionsIcon: UIImageView!
    @IBOutlet weak var topExpensesTitleLabel: UILabel!
    @IBOutlet weak var chartStackView: UIStackView!
    @IBOutlet weak var displayedMonthBG: UIImageView!
    @IBOutlet weak var totalMonthlyAmount: UILabel!
    @IBOutlet weak var totalMonthTitle: UILabel!
    @IBOutlet var arrowButtonCollection: [UIButton]!
    @IBOutlet weak var tableToChartDistanceConstraint: NSLayoutConstraint!
    
    var pageToLoad : Page = .categoryDetails
    
    var expenses : [String : Double] = [:]
    var categories : [Category] = []
    var totalAmountThisMonth : Float = 0.0
    var currentlyDisplayedDate = Date()
    var selectedCategory : String = ""
    let myFinanceManager = FinanceManager.shared
    var transactions = [Transaction]()
    var backStep = 0
    var stackViewSpacing : CGFloat = 8
    let maxStackViewSpacing = 20
    var barHeight : CGFloat = 0
    var stackViewWidth : CGFloat = 0
    let settingManager = SetupManager.shared
    let barChartMultiplier : Float = 0.6 // faktor buat dikaliin ke tinggi bar chart-nya biar gak mentok ke atas
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayedMonthBG.layer.cornerRadius = 9
        displayedMonthBG.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        displayedMonthBG.layer.borderWidth = 1
        
//        graphArea.layer.shadowRadius = 2
//        graphArea.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        graphArea.layer.shadowOffset = CGSize(width: 2, height: 2)
//        graphArea.layer.shadowOpacity = 0.5
        
        chartStackView.axis = .horizontal
        chartStackView.alignment = .leading
        chartStackView.distribution = .fill
        
        for button in arrowButtonCollection {
            button.layer.cornerRadius = button.frame.width / 10
//            button.layer.borderWidth = 1
//            button.layer.borderColor = #colorLiteral(red: 0.3568627451, green: 0.5921568627, blue: 0.8392156863, alpha: 1)
        }
        
        topExpensesTable.delegate = self
        topExpensesTable.dataSource = self
        topExpensesTable.backgroundColor = UIColor.white
        topExpensesTable.layoutIfNeeded()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: Date())
        dateFormatter.dateFormat = "YYYY"
        let year = dateFormatter.string(from: Date())
        displayedMonth.text = "\(nameOfMonth) \(year)"
        nextMonthButton.isEnabled = false
        
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
        
    } // End of viewDidLoad()
    
    override func viewWillAppear(_ animated: Bool) {
        var date = Date()
        categories.removeAll()
        totalAmountThisMonth = 0.0
        date = Calendar.current.date(byAdding: .month, value: -(backStep), to: Date().startOfMonth().endOfDay )!
        loadData(fromDate: date)
        print ("Report - viewWillAppear - CATEGORIES COUNT: ", categories.count)
       
    }
    
    func highestExpenseValue () -> Double {
        var highest : Double = 0
        for expense in expenses {
            if highest < expense.value {
                highest = expense.value
            }
        }
        return highest
    } // end of highestExpenseValue () -> Float
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? ReportCategoryDetailsViewController {
            detailVC.selectedCategory = self.selectedCategory
            detailVC.transactions = self.transactions
            detailVC.currentlyDisplayedDate = currentlyDisplayedDate
            detailVC.backStep = self.backStep
            detailVC.pageToLoad = self.pageToLoad
        }
    } // end of prepare(for segue: UIStoryboardSegue, sender: Any?)
    
    @IBAction func detailsButtonTapped(_ sender: Any) {
        self.selectedCategory = "Transactions List"
        self.pageToLoad = .reportDetails
        self.performSegue(withIdentifier: "reportDetailSegue", sender: nil)
    }
    
    @IBAction func dateToggleButtonPressed(_ sender: UIButton) {
        
        var date = Date()
        categories.removeAll()
        
        if sender.tag == 0 { // Back
            backStep += 1
            date = Calendar.current.date(byAdding: .month, value: -(backStep), to: Date().startOfMonth().endOfDay )!
            totalAmountThisMonth = 0.0
            loadData(fromDate: date)
            nextMonthButton.isEnabled = true
        } else { // Next
            backStep -= 1
            date = Calendar.current.date(byAdding: .month, value: -(backStep), to: Date().startOfMonth().endOfDay )!
            totalAmountThisMonth = 0.0
            loadData(fromDate: date)
            nextMonthButton.isEnabled = backStep == 0 ? false : true
        }
        
        currentlyDisplayedDate = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "YYYY"
        let year = dateFormatter.string(from: date)
        displayedMonth.text = "\(nameOfMonth) \(year)"
    }
    
    func loadData (fromDate date: Date) {
        // REQUEST data untuk bulan ini
        
        let myTransaction = myFinanceManager.getExpenseResultController(fromDate: date.startOfMonth(), toDate: date.endOfMonth().endOfDay) as? NSFetchedResultsController<NSFetchRequestResult>
        myTransaction?.delegate = self
        
        do {
            try myTransaction?.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        
        // LOAD transactions data
        guard let data = myTransaction?.fetchedObjects as? [Transaction] else {return}
        transactions = data
        
        expenses = createDictionaryCategoryValue() // convert fetched data into [String : Double]
        let tempExpenses = expenses.sorted(by: { $0.value > $1.value } )
        
        var tempCat : [Category] = []
        for temp in tempExpenses {
            for cat in categories {
                if temp.key == cat.desc {
                    tempCat.append(cat)
                }
            }
        }
        categories = tempCat
        setupBarChart()
        topExpensesTable.reloadData()
        print ("NUMBER OF CATEGORIES LOADED: ", categories.count)
    }
    
    func createDictionaryCategoryValue () -> [String : Double] { // untuk total amount masing2 category
        var tempDict : [String : Double] = [:]
        for transaction in transactions {
            if (tempDict.index(forKey: (transaction.category?.desc)!) == nil){
//                print ("Create Dictionary - nil - ", (transaction.category?.desc)!)
                tempDict[(transaction.category?.desc)!] = transaction.amount
                categories.append((transaction.category)!)
            } else {
//                print ("Create Dictionary - ", (transaction.category?.desc)!)
                tempDict[(transaction.category?.desc)!]! += transaction.amount
            }
        }
        return tempDict
    }
    
    func setupBarChart() {
        
        // Kalo bar chart nya udah ada, clear dulu Stackview nya untuk diisi bar chart yang baru.
        // just in case jumlah categorynya belom tentu sama semua.
        
        if chartStackView.arrangedSubviews.count != 0 {
//            print("Clearing chartStackView")
            for subView in chartStackView.arrangedSubviews {
                subView.removeFromSuperview()
            }
            
        }
        
        if transactions.count == 0 {
            noTransactionsLabel.isHidden = false
            noTransactionsIcon.isHidden = false
            topExpensesTable.isHidden = true
            chartStackView.isHidden = true
            topExpensesTable.isHidden = true
            topExpensesTitleLabel.isHidden = true
            totalMonthlyAmount.isHidden = true
            
        } else {
            noTransactionsLabel.isHidden = true
            noTransactionsIcon.isHidden = true
            topExpensesTable.isHidden = false
            chartStackView.isHidden = false
            topExpensesTable.isHidden = false
            topExpensesTitleLabel.isHidden = false
            totalMonthlyAmount.isHidden = false
        }
        
        if categories.count != 0 {
            stackViewWidth = barHeight * CGFloat(categories.count) + (CGFloat(categories.count - 1) * stackViewSpacing)
            chartStackView.spacing = CGFloat(stackViewSpacing)
            view.addSubview(chartStackView)
            
            let highestExpenseVal = highestExpenseValue()
            
            let categoryChartStackView = UIStackView()
            categoryChartStackView.axis = .vertical
            categoryChartStackView.alignment = .trailing
            categoryChartStackView.distribution = .fillProportionally
            categoryChartStackView.spacing = stackViewSpacing
            
            let barChartStackView = UIStackView()
            barChartStackView.axis = .vertical
            barChartStackView.alignment = .leading
            barChartStackView.distribution = .fillEqually
            barChartStackView.spacing = stackViewSpacing
            
            let categoryChartStackViewWidthConstraint = NSLayoutConstraint(item: categoryChartStackView, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
            categoryChartStackView.addConstraint(categoryChartStackViewWidthConstraint)
            
            categoryChartStackView.frame = CGRect (x: 0, y: 0, width: 100, height: chartStackView.frame.height)
            barChartStackView.frame = CGRect (x: 0, y: 0, width: barChartStackView.frame.width, height: chartStackView.frame.height)
            chartStackView.addArrangedSubview(categoryChartStackView)
            chartStackView.addArrangedSubview(barChartStackView)
            
            for category in categories {
                
                var barWidth : CGFloat = 0
                
                let categoryLabel = UILabel()
                categoryLabel.font = categoryLabel.font.withSize(12)
                categoryLabel.text = category.desc!
                categoryChartStackView.addArrangedSubview(categoryLabel)
                
                if highestExpenseVal != 0 {
                    barWidth = CGFloat(Float(expenses[category.desc!]!) / Float(highestExpenseVal) * (Float(chartStackView.bounds.width) * barChartMultiplier))
                }
                
                categoryChartStackView.layoutIfNeeded()
                barHeight = (categoryLabel.frame.height)
                
                let expenseBar = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: barWidth, height: barHeight))
                expenseBar.image = #imageLiteral(resourceName: "emptyImage10px") // harus diisi image, kalo engga, gak nongol bar nya
                expenseBar.backgroundColor = UIColor.init(hexString: category.colorCode!)
                expenseBar.translatesAutoresizingMaskIntoConstraints = false;
                
                let expenseBarWidthConstraint = NSLayoutConstraint(item: expenseBar, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: CGFloat(barWidth))
                expenseBarWidthConstraint.isActive = true
                
                let expenseBarHeightConstraint = NSLayoutConstraint(item: expenseBar, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: CGFloat(barHeight))
                expenseBarHeightConstraint.isActive = true
                
                expenseBar.addConstraint(expenseBarHeightConstraint)
                expenseBar.addConstraint(expenseBarWidthConstraint)
                expenseBar.clipsToBounds = true
                expenseBar.layer.cornerRadius = CGFloat(barHeight / 2)
                
                // animasi batang memanjang
                
                if highestExpenseVal != 0 {
                    let animationDuration : Double = Double(expenses[category.desc!]!) / Double(highestExpenseVal) * 0.8
                    expenseBar.frame = CGRect(x: 0.0, y: 0.0, width: 0.0, height: CGFloat(barHeight))
                    UIView.animate(withDuration: animationDuration, delay: 0.0, options: .curveEaseOut, animations: {
                        expenseBar.frame = CGRect(x: 0.0, y: 0.0, width: CGFloat(barWidth), height: CGFloat(self.barHeight))
                    }, completion: { (Bool) in
                        
                    })
                }
                
                barChartStackView.addArrangedSubview(expenseBar)
                barChartStackView.layoutIfNeeded()
                totalAmountThisMonth += Float(expenses[category.desc!]!)
                
//                if barNumber == 5 {
//                    let gradient = CAGradientLayer()
//                    gradient.frame = expenseBar.frame
//                    let color1 = UIColor.black.withAlphaComponent(0.5)
//                    let color2 = UIColor.black.withAlphaComponent(0)
//                    gradient.colors = [color1, color2]
//                    expenseBar.layer.mask = gradient
//                    
//                } else if barNumber > 5 {
//                    expenseBar.alpha = 0
//                }
            }
//            print ("BAR STACK VIEW: ", barChartStackView.arrangedSubviews  )
            let locale = Locale.current
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimumFractionDigits = SetupManager.shared.isUserUsingDecimal ? 2 : 0
            formatter.maximumFractionDigits = SetupManager.shared.isUserUsingDecimal ? 2 : 0
            totalMonthlyAmount.text = "\(locale.currencySymbol!) \(formatter.string(from: NSNumber(value: totalAmountThisMonth)) ?? "$")"
            totalMonthlyAmount.textColor = totalMonthTitle.textColor
            totalMonthTitle.text = "   Total \(displayedMonth.text!)"
            chartStackView.layoutIfNeeded()
            self.view.sendSubviewToBack(chartStackView)
            print("CHART STACK VIEW HEIGHT: ", chartStackView.frame.height)
//            if chartStackView.frame.height > (barHeight + stackViewSpacing) * 5 {
//                let offset = chartStackView.frame.height - (barHeight + stackViewSpacing) * 5
//                tableToChartDistanceConstraint.constant = 0 - offset
//            }
        }
    }
}

extension ReportViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print ("CATEGORIES COUNT: ", categories.count)
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print ("POPULATING CELL")
        let cell = tableView.dequeueReusableCell(withIdentifier: "topExpenseCell") as! ReportTableViewCell
        
        if categories.count != 0 {
            cell.categorySymbolImageView.image = #imageLiteral(resourceName: "emptyImage10px")
            cell.categorySymbolImageView.layer.cornerRadius = cell.categorySymbolImageView.frame.width / 2
            cell.categorySymbolImageView.layer.borderWidth = 0
            let bgColor = categories[indexPath.row].colorCode!
            cell.categorySymbolImageView.layer.backgroundColor = UIColor(hexString: bgColor).cgColor
            cell.expenseCategory.text = categories[indexPath.row].desc!
            cell.backgroundColor = UIColor.clear
            
            let locale = Locale.current
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimumFractionDigits = SetupManager.shared.isUserUsingDecimal ? 2 : 0
            formatter.maximumFractionDigits = SetupManager.shared.isUserUsingDecimal ? 2 : 0
            let expenseValue = locale.currencySymbol! + " " + formatter.string(from: NSNumber(value: expenses[categories[indexPath.row].desc!]!))!
            cell.expenseCategoryValue.text = expenseValue
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .blue
        }
            return cell
//        cell.backgroundColor = indexPath.row % 2 == 0 ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0.3568627451, green: 0.5921568627, blue: 0.8392156863, alpha: 0.2492847711) // Buat alternate color cell row nya
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCategory = categories[indexPath.row].desc!
        self.pageToLoad = .categoryDetails
        self.performSegue(withIdentifier: "reportDetailSegue", sender: nil)
    }
}

extension ReportViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // setiap ada perubahan data, func ini akan di call
        // sorting dulu, trus reloadData
        if categories.count != 0 {
            topExpensesTable.reloadData()
        }
    }
}

