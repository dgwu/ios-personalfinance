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
    var categories : [String] = []
    var totalAmountThisMonth : Float = 0.0
    var currentlyDisplayedDate = Date()
    var decimalSetting : Bool = true
    var selectedCategory : String = ""
    let myFinanceManager = FinanceManager.shared
    var transactions = [Transaction]()
    var backStep = 0
    var stackViewSpacing = 5
    let maxStackViewSpacing = 20
    var barWidth = 1
    let maxBarWidth = 40
    var stackViewWidth = 0
    var categoryColors : [UIColor] = [#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), #colorLiteral(red: 0.4575039148, green: 1, blue: 0.718978703, alpha: 1), #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1), #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1), #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1),]
    
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
        chartStackView.distribution = .equalCentering
        
        legendStackView.axis = .horizontal
        legendStackView.alignment = .leading
        legendStackView.distribution = .fillEqually
        legendStackView.spacing = CGFloat(30)
//        legendStackView.heightAnchor.constraint(equalTo: <#T##NSLayoutDimension#>, multiplier: <#T##CGFloat#>)
        
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
        
        setupBarChart()
        
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
        
        // Olah data transactions
        
        
        
    } // End of viewDidLoad()
    
    override func viewWillAppear(_ animated: Bool) {
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
                categories.append((transaction.category?.desc)!)
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
                chartStackView.removeArrangedSubview(subView)
            }
        }
        
        if transactions.count == 0 {
            noTransactionsLabel.isHidden = false
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
            legendStackView.removeArrangedSubview(subView)
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
            legendVerticalStackViewLeft.frame = CGRect(x: 0, y: 0, width: chartStackView.frame.width / 2, height: 1)
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
                let buttonHeight = Float(expenses[category]!) / Float(highestExpenseVal) * (Float(graphAxisArea.bounds.height) * barChartMultiplier)
                //            print ("Button Height", buttonHeight)
                let expenseBarButton = UIButton(frame: CGRect(x: 0, y: 0, width: barWidth, height: Int(buttonHeight)))
//                let colorAlpha = 0.4 + (expenses[category]! / highestExpenseVal * 0.6)
                expenseBarButton.backgroundColor = categoryColors[categories.firstIndex(of: category)!] //UIColor(displayP3Red: 0.3, green: 0.1, blue: 0.5, alpha: CGFloat(colorAlpha))
                expenseBarButton.translatesAutoresizingMaskIntoConstraints = false;
                let expenseBarHeightConstraint = NSLayoutConstraint(item: expenseBarButton, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: CGFloat(buttonHeight))
                expenseBarHeightConstraint.isActive = true
                expenseBarButton.addConstraint(expenseBarHeightConstraint)
                expenseBarButton.titleLabel?.text = category
                expenseBarButton.addTarget(self, action: #selector(self.expenseBarButtonTapped(sender:)), for: .touchUpInside)
                //            print("Bar Position: \(expenseBarButton.frame.minX), \(expenseBarButton.frame.minY)")
                chartStackView.addArrangedSubview(expenseBarButton)
                //            print ("Constraints: ", expenseBarButton.constraints[0].constant)
                
                
                // SETUP LEGEND UNTUK BAR CHART
                let newHorizontalStackView = UIStackView()
                newHorizontalStackView.axis = .horizontal
                newHorizontalStackView.alignment = .center
                newHorizontalStackView.spacing = 5
                
                let colorLegend = UIImageView()
                colorLegend.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
                colorLegend.layer.borderWidth = 0
                colorLegend.layer.cornerRadius = 2
                colorLegend.image = UIImage(named: "emptyImage10px.png")
                colorLegend.backgroundColor = categoryColors[categories.firstIndex(of: category)!]
                colorLegend.contentMode = .scaleAspectFit
                view.addSubview(colorLegend)
                
                let legendLabel = UILabel()
                legendLabel.text = category
                legendLabel.font = legendLabel.font.withSize(10)
                
                newHorizontalStackView.addArrangedSubview(colorLegend)
                newHorizontalStackView.addArrangedSubview(legendLabel)
                
                totalAmountThisMonth += Float(expenses[category]!)
                
                if categories.firstIndex(of: category)! % 2 == 0 {
                    legendVerticalStackViewLeft.addArrangedSubview(newHorizontalStackView)
                } else {
                    legendVerticalStackViewRight.addArrangedSubview(newHorizontalStackView)
                }
            }
            
//            print ("CHART STACK VIEW = ", chartStackView.arrangedSubviews )
 
            yAxisTopLabel.text = formatYAxisLabel(number: highestExpenseVal)
            yAxisMiddleLabel.text = formatYAxisLabel(number: highestExpenseVal / 2)
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.maximumFractionDigits = decimalSetting ? 2 : 0
            totalMonthlyAmount.text = formatter.string(from: NSNumber(value: totalAmountThisMonth))
            totalMonthlyAmount.textColor = totalMonthTitle.textColor
            totalMonthTitle.text = "   Total \(displayedMonth.text!)"
            
        } else {
            
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
        print ("Categories count: ", categories.count)
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "topExpenseCell") as! ReportTableViewCell
        if categories.count != 0 {
            
            cell.rank.text = String(indexPath.row+1)
            cell.expenseCategory.text = categories[indexPath.row]
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.maximumFractionDigits = decimalSetting ? 2 : 0
            let expenseValue = formatter.string(from: NSNumber(value: expenses[categories[indexPath.row]]!))
            cell.expenseCategoryValue.text = expenseValue
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
        }
            return cell
//        cell.backgroundColor = indexPath.row % 2 == 0 ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0.3568627451, green: 0.5921568627, blue: 0.8392156863, alpha: 0.2492847711) // Buat alternate color cell row nya
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCategory = categories[indexPath.row]
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

