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
    @IBOutlet weak var graphAxisArea: UIImageView!
    @IBOutlet weak var noTransactionsLabel: UILabel!
    @IBOutlet weak var noTransactionsIcon: UIImageView!
    @IBOutlet weak var topExpensesTitleLabel: UILabel!
    @IBOutlet weak var yAxisMiddleLabel: UILabel!
    @IBOutlet weak var yAxisTopLabel: UILabel!
    @IBOutlet weak var graphArea: UIImageView!
    @IBOutlet weak var chartStackView: UIStackView!
    @IBOutlet weak var legendStackView: UIStackView!
    @IBOutlet weak var displayedMonthBG: UIImageView!
    @IBOutlet weak var totalMonthlyAmount: UILabel!
    @IBOutlet weak var totalMonthTitle: UILabel!
    
    @IBOutlet var arrowButtonCollection: [UIButton]!
    
    var pageToLoad : Page = .categoryDetails
    
    var expenses : [String : Double] = [:]
    var categories : [Category] = []
    var totalAmountThisMonth : Float = 0.0
    var currentlyDisplayedDate = Date()
    var decimalSetting : Bool = true
    var selectedCategory : String = ""
    let myFinanceManager = FinanceManager.shared
    var transactions = [Transaction]()
    var backStep = 0
    var stackViewSpacing = 10
    let maxStackViewSpacing = 20
    var barWidth = 10
    let maxBarWidth = 40
    var stackViewWidth = 0
    
    let barChartMultiplier : Float = 0.95 // faktor buat dikaliin ke tinggi bar chart-nya biar gak mentok ke atas
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayedMonthBG.layer.cornerRadius = 9
        displayedMonthBG.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        displayedMonthBG.layer.borderWidth = 1
        
        graphArea.layer.cornerRadius = 9
        graphArea.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        graphArea.layer.borderWidth = 1
        
//        graphArea.layer.shadowRadius = 2
//        graphArea.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        graphArea.layer.shadowOffset = CGSize(width: 2, height: 2)
//        graphArea.layer.shadowOpacity = 0.5
        
        chartStackView.axis = .horizontal
        chartStackView.alignment = .bottom
        chartStackView.distribution = .fillEqually
        
        legendStackView.axis = .horizontal
        legendStackView.alignment = .leading
        legendStackView.distribution = .fillEqually
        legendStackView.spacing = CGFloat(30)
        
        for button in arrowButtonCollection {
            button.layer.cornerRadius = button.frame.width / 10
//            button.layer.borderWidth = 1
//            button.layer.borderColor = #colorLiteral(red: 0.3568627451, green: 0.5921568627, blue: 0.8392156863, alpha: 1)
        }
        
        topExpensesTable.delegate = self
        topExpensesTable.dataSource = self
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: Date())
        dateFormatter.dateFormat = "YYYY"
        let year = dateFormatter.string(from: Date())
        displayedMonth.text = "\(nameOfMonth) \(year)"
        nextMonthButton.isEnabled = false
        loadData(fromDate: Date())
        
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
        date = Calendar.current.date(byAdding: .month, value: -(backStep), to: Date().startOfMonth().endOfDay )!
        loadData(fromDate: date)
        setupBarChart()
        topExpensesTable.reloadData()
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
    
    @objc func expenseBarButtonTapped (sender: UIButton) {
//        self.selectedCategory = (sender.titleLabel?.text)!
//        self.pageToLoad = .categoryDetails
//        self.performSegue(withIdentifier: "reportDetailSegue", sender: nil)
//        print ("Selected Category (Button) = ", self.selectedCategory)
    }
    
    @IBAction func detailsButtonTapped(_ sender: Any) {
        self.selectedCategory = "Transactions List"
        self.pageToLoad = .reportDetails
        self.performSegue(withIdentifier: "reportDetailSegue", sender: nil)
    }
    
    @IBAction func dateToggleButtonPressed(_ sender: UIButton) {
        
        var date = Date()
        print ("Categories count BEFORE REMOVE: ", categories.count)
        categories.removeAll()
        print ("Categories count AFTER REMOVE: ", categories.count)
        if sender.tag == 0 { // Back
            backStep += 1
            date = Calendar.current.date(byAdding: .month, value: -(backStep), to: Date().startOfMonth().endOfDay )!
            loadData(fromDate: date)
            nextMonthButton.isEnabled = true
        } else { // Next
            backStep -= 1
            date = Calendar.current.date(byAdding: .month, value: -(backStep), to: Date().startOfMonth().endOfDay )!
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
        
        setupBarChart()
        topExpensesTable.reloadData()
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
            graphArea.isHidden = true
            yAxisTopLabel.isHidden = true
            yAxisMiddleLabel.isHidden = true
            graphAxisArea.isHidden = true
            legendStackView.isHidden = true
            
        } else {
            noTransactionsLabel.isHidden = true
            noTransactionsIcon.isHidden = true
            topExpensesTable.isHidden = false
            chartStackView.isHidden = false
            topExpensesTable.isHidden = false
            topExpensesTitleLabel.isHidden = false
            totalMonthlyAmount.isHidden = false
            graphArea.isHidden = false
            yAxisTopLabel.isHidden = false
            yAxisMiddleLabel.isHidden = false
            graphAxisArea.isHidden = false
            legendStackView.isHidden = false
        }
        
        for subView in legendStackView.arrangedSubviews {
            subView.removeFromSuperview()
//            legendStackView.removeArrangedSubview(subView)
        }
        
        if categories.count != 0 {//            let graphWidth = graphAxisArea.frame.width
            stackViewWidth = barWidth * categories.count + ((categories.count - 1) * stackViewSpacing)
            chartStackView.spacing = CGFloat(stackViewSpacing)
            chartStackView.distribution = .fillEqually
//            let chartStackViewWidthConstraint = NSLayoutConstraint(item: chartStackView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: graphWidth * 0.95)
//            chartStackView.addConstraint(chartStackViewWidthConstraint)
            view.addSubview(chartStackView)
            view.addSubview(graphAxisArea) // ini biar posisi garis chart nya ada di atas bar chart nya
            
            let legendVerticalStackViewLeft = UIStackView()
            legendVerticalStackViewLeft.axis = .vertical
            legendVerticalStackViewLeft.alignment = .leading
            legendVerticalStackViewLeft.frame = CGRect(x: 0, y: 0, width: graphAxisArea.frame.width / 2, height: 1)
            legendVerticalStackViewLeft.spacing = CGFloat(2)
            
            let legendVerticalStackViewRight = UIStackView()
            legendVerticalStackViewRight.axis = .vertical
            legendVerticalStackViewRight.alignment = .leading
            legendVerticalStackViewRight.frame = legendVerticalStackViewLeft.frame
            legendVerticalStackViewRight.spacing = legendVerticalStackViewLeft.spacing
            
            legendStackView.addArrangedSubview(legendVerticalStackViewLeft)
            legendStackView.addArrangedSubview(legendVerticalStackViewRight)
            
            let highestExpenseVal = highestExpenseValue()
            
            chartStackView.frame = CGRect(x: graphAxisArea.frame.midX, y: graphAxisArea.frame.minY, width: CGFloat(stackViewWidth), height: (graphAxisArea.frame.height * CGFloat(barChartMultiplier)))
            chartStackView.center = CGPoint(x: graphAxisArea.frame.midX, y: graphAxisArea.frame.midY + ((graphAxisArea.frame.height - chartStackView.frame.height) / 2))
            
//            let chartStackViewBottomConstraint = NSLayoutConstraint(item: chartStackView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: graphArea, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
//            chartStackView.addConstraint(chartStackViewBottomConstraint)
            
            for category in categories {
                let buttonHeight = Float(expenses[category.desc!]!) / Float(highestExpenseVal) * (Float(graphAxisArea.bounds.height) * barChartMultiplier)
                //            print ("Button Height", buttonHeight)
                let expenseBarButton = UIButton(frame: CGRect(x: 0, y: 0, width: barWidth, height: Int(buttonHeight)))
//                let colorAlpha = 0.4 + (expenses[category]! / highestExpenseVal * 0.6)
                expenseBarButton.backgroundColor = UIColor.init(hexString: category.colorCode!) //UIColor(displayP3Red: 0.3, green: 0.1, blue: 0.5, alpha: CGFloat(colorAlpha))
                expenseBarButton.translatesAutoresizingMaskIntoConstraints = false;
                let expenseBarHeightConstraint = NSLayoutConstraint(item: expenseBarButton, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: CGFloat(buttonHeight))
                expenseBarHeightConstraint.isActive = true
                expenseBarButton.addConstraint(expenseBarHeightConstraint)
                expenseBarButton.titleLabel?.text = category.desc
                expenseBarButton.addTarget(self, action: #selector(self.expenseBarButtonTapped(sender:)), for: .touchUpInside)
                //            print("Bar Position: \(expenseBarButton.frame.minX), \(expenseBarButton.frame.minY)")
                // ini buat bikin round corner di bagian atas bar-nya doank
                if #available(iOS 11.0, *) {
                    expenseBarButton.clipsToBounds = true
                    expenseBarButton.layer.cornerRadius = 8
                    expenseBarButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                }
                
                // animasi bar chart naik
                let animationDuration : Double = Double(expenses[category.desc!]!) / Double(highestExpenseVal) * 0.8
                expenseBarButton.frame = CGRect(x: 0.0, y: CGFloat(buttonHeight), width: CGFloat(barWidth), height: 0.0)
                UIView.animate(withDuration: animationDuration) {
                    expenseBarButton.frame = CGRect(x: 0.0, y: 0.0, width: CGFloat(self.barWidth), height: CGFloat(buttonHeight))
                }
                
                chartStackView.addArrangedSubview(expenseBarButton)
                
                // SETUP LEGEND UNTUK BAR CHART
                let newHorizontalStackView = UIStackView()
                newHorizontalStackView.axis = .horizontal
                newHorizontalStackView.alignment = .center
                newHorizontalStackView.spacing = 5
                
                let colorLegend = UIImageView()
                colorLegend.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
                colorLegend.layer.borderWidth = 0
                colorLegend.layer.cornerRadius = colorLegend.frame.width / 2
                colorLegend.image = UIImage(named: "emptyImage10px.png")
                colorLegend.backgroundColor = UIColor(hexString: category.colorCode!)
                colorLegend.contentMode = .scaleAspectFit
                view.addSubview(colorLegend)
                
                let legendLabel = UILabel()
                legendLabel.text = category.desc!
                legendLabel.font = legendLabel.font.withSize(10)
                
                newHorizontalStackView.addArrangedSubview(colorLegend)
                newHorizontalStackView.addArrangedSubview(legendLabel)
                
                totalAmountThisMonth += Float(expenses[category.desc!]!)
                
                if categories.firstIndex(of: category)! % 2 == 0 {
                    legendVerticalStackViewLeft.addArrangedSubview(newHorizontalStackView)
                } else {
                    legendVerticalStackViewRight.addArrangedSubview(newHorizontalStackView)
                }
            }
            
            yAxisTopLabel.text = formatYAxisLabel(number: highestExpenseVal)
            yAxisMiddleLabel.text = formatYAxisLabel(number: highestExpenseVal / 2)
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.maximumFractionDigits = decimalSetting ? 2 : 0
            totalMonthlyAmount.text = formatter.string(from: NSNumber(value: totalAmountThisMonth))
            totalMonthlyAmount.textColor = totalMonthTitle.textColor
            totalMonthTitle.text = "   Total \(displayedMonth.text!)"
            
            print ("STACKVIEW WIDTH = ", chartStackView.frame.width)
            let spaceForSpacing = (chartStackView.arrangedSubviews.count - 1) * Int(chartStackView.spacing)
            print ("Space for spacing: ", spaceForSpacing )
            barWidth = (Int(chartStackView.frame.width) - spaceForSpacing) / chartStackView.arrangedSubviews.count
            print ("Arranged subcviews.count: ", chartStackView.arrangedSubviews.count)
            print ("Bar Width: ", barWidth)
            for view in chartStackView.arrangedSubviews {
                view.layer.cornerRadius = CGFloat(barWidth / 2)
            }
        }
    }
    
    func formatYAxisLabel (number : Double) -> String {
        var formattedNumber : String = ""
        var power : Double = 0
        var postfix : String = ""
        let myNumberFormatter = NumberFormatter()
        myNumberFormatter.minimumFractionDigits = 1
        myNumberFormatter.maximumFractionDigits = 1
        myNumberFormatter.minimumIntegerDigits = 1
        
        if String(Int(number)).count > 12 {
            power = 12
            postfix = "T"
        } else if String(Int(number)).count > 9 {
            power = 9
            postfix = "B"
        } else if String(Int(number)).count > 6 {
            power = 6
            postfix = "M"
        } else if String(Int(number)).count > 3 {
            power = 3
            postfix = "K"
        } else {
            power = 0
            postfix = ""
        }
        
        let newNumber = number / pow(10, power)
        formattedNumber = "\(myNumberFormatter.string(for: newNumber)!)\(postfix)"
        return formattedNumber
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
            cell.rank.text = String(indexPath.row+1)
            let rankLabelWidth = cell.rank.font.pointSize * 2.5
            cell.rank.layer.cornerRadius = rankLabelWidth / 2
            cell.rank.layer.borderWidth = rankLabelWidth / 8
            let borderColor = categories[indexPath.row].colorCode!
            cell.rank.layer.borderColor = UIColor(hexString: borderColor).cgColor
            cell.expenseCategory.text = categories[indexPath.row].desc!
            cell.rank.widthAnchor.constraint(equalToConstant: rankLabelWidth).isActive = true
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.maximumFractionDigits = decimalSetting ? 2 : 0
            let expenseValue = formatter.string(from: NSNumber(value: expenses[categories[indexPath.row].desc!]!))
            cell.expenseCategoryValue.text = expenseValue
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
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

