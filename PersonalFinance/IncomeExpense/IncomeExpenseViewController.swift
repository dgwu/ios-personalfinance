//
//  IncomeExpenseViewController.swift
//  PersonalFinance
//
//  Created by Daniel Gunawan on 11/12/18.
//  Copyright © 2018 Daniel Gunawan. All rights reserved.
//

import UIKit
import Foundation

class IncomeExpenseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    

    @IBOutlet weak var tableExpenses: UITableView!
    
    @IBOutlet weak var viewBudget: UIView!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var remainingBudgetLabel: UILabel!
    @IBOutlet weak var notifBudgetLabel: UILabel!
    @IBOutlet weak var addRecordButton: UIButton!
    @IBOutlet weak var latesExpenseButton: UIButton!
    @IBOutlet weak var viewLatestExpense: UIView!
    
    @IBOutlet weak var recordView: UIView!
    
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var noteTextField: UITextField!
    var condotion : Int = 0
    
    @IBOutlet weak var buttonSave: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("height  = \(self.view.frame.height)")
        tableExpenses.delegate = self
        tableExpenses.dataSource = self
        self.viewLatestExpense.alpha = 0
        self.recordView.alpha = 0
        GestureRec()
        GetDate()
        CustomUi()
        
        
        
            }

    //Lates Button
    @IBAction func LatestButton(_ sender: Any) {
        condotion = 1
    UIView.animate(withDuration: 1, animations: {
        self.latesExpenseButton.frame.origin.y = (self.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height + 15
        self.latesExpenseButton.transform = CGAffineTransform(scaleX: 1.25, y: 1)
        self.logoView.alpha = 0
        self.viewBudget.frame.origin.y = self.view.frame.height - ((self.tabBarController?.tabBar.frame.size.height)!) - self.viewBudget.frame.height
        self.viewLatestExpense.frame.origin.y = (self.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height + self.latesExpenseButton.frame.height + 15
        self.addRecordButton.frame.origin.y = self.view.frame.height
        self.notifBudgetLabel.alpha = 1
        self.viewLatestExpense.alpha = 1
        self.addRecordButton.alpha = 0
        self.latesExpenseButton.layer.cornerRadius = 10
    }, completion: nil)
        print( "nilai condition \(condotion)")
    }
    
    
    func GestureRec()  {
        viewBudget.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.TapGesture))
        viewBudget.addGestureRecognizer(tap)
        _ = UITapGestureRecognizer(target: self, action: #selector(self.dissmisKeyboard))
    }
    
    @objc func TapGesture (){
           if condotion == 1{
            print("ini condition = \(condotion)")
        UIView.animate(withDuration: 1, animations: {
            self.viewLatestExpense.frame.origin.y = self.view.frame.height/2
            self.viewLatestExpense.alpha = 0
            self.viewBudget.frame.origin.y = self.view.frame.height/2 - (self.viewBudget.frame.height/2)
            self.latesExpenseButton.frame.origin.y = self.view.frame.height/2 - (self.viewBudget.frame.height/2) - (self.latesExpenseButton.frame.height + 10)
            self.addRecordButton.frame.origin.y = self.view.frame.height/2 + (self.viewBudget.frame.height/2) + 10
            self.latesExpenseButton.transform = .identity
            self.addRecordButton.transform = .identity
            self.addRecordButton.alpha = 1
            self.latesExpenseButton.alpha = 1
            self.recordView.alpha = 0
            self.latesExpenseButton.layer.cornerRadius = 20
            self.addRecordButton.layer.cornerRadius = 20
        }, completion: nil)
        }
        condotion = 0
    }
    
    @objc func dissmisKeyboard()  {
        self.view.endEditing(true)
    }
    
    //Add Record Button
    @IBAction func AddRecord(_ sender: Any) {
        condotion = 1
        UIView.animate(withDuration: 1, animations: {
            self.latesExpenseButton.alpha = 0
            self.latesExpenseButton.frame.origin.y = (self.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height - 15
            self.logoView.alpha = 0
            self.viewBudget.frame.origin.y = (self.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height
            self.recordView.alpha = 0
            self.recordView.frame.origin.y = (self.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height + self.viewBudget.frame.height + 15
            self.addRecordButton.frame.origin.y = (self.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height + self.viewBudget.frame.height + self.recordView.frame.height
            self.addRecordButton.alpha = 0
            self.addRecordButton.transform = CGAffineTransform(scaleX: 1.25, y: 1)
            self.recordView.alpha = 1
            
            
        }, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableExpenses.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        print(" ini dijalankan")
        cell.expansesNameLabel.text = "Wee Nam Kee"
        cell.amountExpensesLabel.text = "Rp 50000"
        cell.imageView?.layer.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        return cell
    }
    
    
    @IBAction func saveButton(_ sender: Any) {
    }
    
    
    
    func GetDate()  {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.addTarget(self, action: #selector(IncomeExpenseViewController.DatePickerValue(sender:)), for: UIControl.Event.valueChanged)
        dateTextField.inputView = datePicker
    }
    
    @objc func DatePickerValue(sender : UIDatePicker)   {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.long
        formatter.timeStyle = DateFormatter.Style.none
        dateTextField.text = formatter.string(from: sender.date)
    }
    
    func CustomUi()  {
        latesExpenseButton.clipsToBounds = true
        addRecordButton.clipsToBounds = true
        latesExpenseButton.layer.cornerRadius =  20
        addRecordButton.layer.cornerRadius = 20
        viewBudget.layer.borderColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        viewBudget.layer.borderWidth = 4
        recordLabel.clipsToBounds = true
        recordLabel.layer.cornerRadius = 10
        latesExpenseButton.layer.borderWidth = 3
        latesExpenseButton.layer.borderColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        addRecordButton.layer.borderWidth = 3
        addRecordButton.layer.borderColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        buttonSave.layer.cornerRadius = 20
        buttonSave.clipsToBounds = true
    }
}


extension IncomeExpenseViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

