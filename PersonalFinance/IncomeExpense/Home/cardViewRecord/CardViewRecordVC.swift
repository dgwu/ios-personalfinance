//
//  CardViewRecordVC.swift
//  PersonalFinance
//
//  Created by Gun Eight  on 04/02/19.
//  Copyright © 2019 Daniel Gunawan. All rights reserved.
//

import UIKit

class CardViewRecordVC: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dateLabel: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var labelAddRecord: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var amountLabel: UITextField!
    @IBOutlet weak var nameExpenseLabel: UITextField!
    @IBOutlet weak var handleView: UIView!
    var categorySelected : Category?
     var prevCoor : CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        GetDate()
    }
    
    func initialSetup (){
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(CardViewRecordVC.panGesture))
        view.addGestureRecognizer(gesture)
        
        let frame = self.view.frame
        let yComponent = UIScreen.main.bounds.height - self.view.center.y
        self.view.frame = CGRect(x: 0, y: yComponent, width: frame.width, height: frame.height)
        self.view.layer.cornerRadius = 15
        self.view.layer.masksToBounds = true
        GetDate()
        amountLabel.becomeFirstResponder()
        amountLabel.keyboardType = .numberPad
        nameExpenseLabel.returnKeyType = .done
        
        handleView.layer.cornerRadius = 2
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
         let category = categorySelected
        let defaultWallet = FinanceManager.shared.defaultWallet()
        guard var expenseDesc = nameExpenseLabel.text else {return}
        
        if expenseDesc.count < 1 {
            expenseDesc = "-"
        }
        FinanceManager.shared.insertExpense(date: datePicker.date, amount: (amountLabel.text! as NSString).doubleValue , category: category!, wallet: defaultWallet!, desc: expenseDesc)
        
    }
  
    @IBAction func saveRecord(_ sender: Any) {
           print(datePicker.date)
        print ((amountLabel.text! as NSString).doubleValue )
        print (categorySelected!)
        print(nameExpenseLabel)
        InsertExpenses()
        view.endEditing(true)
         self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cancelRecord(_ sender: Any) {
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func panGesture(recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        recognizer.setTranslation(CGPoint.zero, in: self.view)
        
        if recognizer.state == .ended
        {

                self.dismiss(animated: true, completion: nil)

        }
    }
}
