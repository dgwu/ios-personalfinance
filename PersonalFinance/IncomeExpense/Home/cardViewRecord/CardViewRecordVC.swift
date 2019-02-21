//
//  CardViewRecordVC.swift
//  PersonalFinance
//
//  Created by Gun Eight  on 04/02/19.
//  Copyright © 2019 Daniel Gunawan. All rights reserved.
//

import UIKit
import CoreData

class CardViewRecordVC: UIViewController {

    @IBOutlet weak var swipeHandler: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dateLabel: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var labelAddRecord: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var amountTextField: UITextField!
    var amountTextFieldCursorOffset = 0
    @IBOutlet weak var nameExpenseLabel: UITextField!
    @IBOutlet weak var handleView: UIView!
    @IBOutlet weak var linelast: UIView!
    @IBOutlet weak var selectCategory: UIButton!
    @IBOutlet weak var requredAmount: UILabel!
    var senderVC: UIViewController?
    var categorySelected : Category?
    var transactionSelected : Transaction?
    var amountTansact : Double?
    var dateEdit : Date?
    var desc : String?
    var statusTemp : Int?
    var prevCoor : CGFloat = 0
    var pickerView  : UIPickerView = UIPickerView()
    var getCategoryForPicker =  FinanceManager.shared.categoryList(type: .expense)
    lazy var textField : UITextField = {
        let text : UITextField = UITextField(frame: CGRect.zero)
        text.inputView = pickerView
        view.addSubview(text)
        return text
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        
        amountTextField.delegate = self
        amountTextField.addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingChanged)
    }
    
    func initialSetup (){
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeDown))
        gesture.direction = .down
//        swipeHandler.addGestureRecognizer(gesture)
        view.addGestureRecognizer(gesture)
        let tapGesture : UITapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        let frame = self.view.frame
        let yComponent = UIScreen.main.bounds.height - self.view.center.y
        self.view.frame = CGRect(x: 0, y: yComponent, width: frame.width, height: frame.height)
        self.view.layer.cornerRadius = 15
        self.view.layer.masksToBounds = true
        amountTextField.becomeFirstResponder()
        if (SetupManager.shared.isUserUsingDecimal) {
            amountTextField.keyboardType = .decimalPad
        } else {
            amountTextField.keyboardType = .numberPad
        }
        
        nameExpenseLabel.returnKeyType = .default
        handleView.layer.cornerRadius = 2
        inputMode()
        pickerView.delegate = self
        pickerView.dataSource = self
        requredAmount.isHidden = true
    }
    
    func inputMode() {
        if statusTemp == 0 {
            selectCategory.isHidden = true
            linelast.isHidden = true
            GetDate()
         
        }else{
            GetDate()

            amountTextField.text = transactionSelected!.amount.prettyAmount()
            nameExpenseLabel.text = "\(transactionSelected!.desc  ?? "-")"
            selectCategory.setTitle("\(transactionSelected?.category?.desc ?? "-")", for: .normal)
            labelAddRecord.text = " Edit Transaction"
            
        }
    }
    
    let datePicker = UIDatePicker()
    func GetDate()  {
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.addTarget(self, action: #selector(self.DatePickerValue(sender:)), for: .valueChanged)
        guard let dates =  dateLabel else {
            return
        }
        if statusTemp == 0 {
            if datePicker == datePicker {
                dates.inputView = datePicker
                dates.text = "Today"
            }
        }else if statusTemp == 1{
            let formatter = DateFormatter()
            formatter.dateStyle = DateFormatter.Style.long
            formatter.timeStyle = DateFormatter.Style.none
            dates.inputView = datePicker
            dateEdit = transactionSelected?.transactionDate
            guard let datelabels = dateLabel else { return}
            datelabels.text = formatter.string(from: dateEdit!)
        }else{
            dates.inputView = datePicker
        }
        self.view.endEditing(true)
    }
        
    @objc func DatePickerValue(sender : UIDatePicker)   {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.long
        formatter.timeStyle = DateFormatter.Style.none
        self.dateLabel.text = formatter.string(from: datePicker.date)
        }
    
    func update (transaction: Transaction) {
       let update = FinanceManager.shared.objectContext.object(with: transaction.objectID)
        update.setValuesForKeys(["amount" : transaction.amount, "createdDate" : transaction.transactionDate!, "desc": transaction.desc!, "category": transaction.category! ] )
        do {
            try FinanceManager.shared.objectContext.save()
            print("success")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func InsertExpenses()   {
        print("insert Expenses")
        guard let cat = categorySelected else { return }
        let defaultWallet = FinanceManager.shared.defaultWallet()
        guard var expenseDesc = nameExpenseLabel.text else {return}
        print("ini category :\(cat)")
        if expenseDesc.count < 1 {
            expenseDesc = "-"
        }
//        FinanceManager.shared.insertExpense(date: datePicker.date, amount: (amountTextField.text! as NSString).doubleValue , category: cat, wallet: defaultWallet!, desc: expenseDesc)
        // modif by dg
        FinanceManager.shared.insertExpense(date: datePicker.date, amount: amountTextField.text?.removePrettyNumberFormat() ?? 0 , category: cat, wallet: defaultWallet!, desc: expenseDesc)
    }
    
    @IBAction func selectCategoryAction(_ sender: Any) {
        textField.becomeFirstResponder()
    }
    
    @IBAction func saveRecord(_ sender: Any) {
        
        if (amountTextField.text?.isEmpty)!{
            requredAmount.isHidden = false
        } else if statusTemp == 0 {
            InsertExpenses()
            view.endEditing(true)
            self.dismiss(animated: true, completion: nil)
        }else{
//            transactionSelected?.amount = (amountTextField.text! as NSString).doubleValue
            transactionSelected?.amount = amountTextField.text?.removePrettyNumberFormat() ?? 0
            transactionSelected?.category = categorySelected
            transactionSelected?.transactionDate = datePicker.date
            transactionSelected?.desc = nameExpenseLabel.text
            update(transaction: transactionSelected!)
            view.endEditing(true)
            self.dismiss(animated: true, completion: nil)
            senderVC?.viewWillAppear(false)
        }
            
       
    }
    
    @IBAction func cancelRecord(_ sender: Any) {
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func swipeDown() {
         self.dismiss(animated: true, completion: nil)
    }

    @objc override func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension CardViewRecordVC : UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        print("count : \(getCategoryForPicker?.count ?? 0)")
        return getCategoryForPicker?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categorySelected = getCategoryForPicker![row]
        selectCategory.setTitle("\(getCategoryForPicker![row].desc ?? "-")", for: .normal)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return getCategoryForPicker![row].desc
    }

}


extension CardViewRecordVC: UITextFieldDelegate {
    @objc func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.amountTextField {
            let amountString = textField.text ?? ""
            if amountString.isValidDouble() {
                if textField.text?.last != "." && textField.text?.first != "." {
                    textField.text = amountString.removePrettyNumberFormat()?.prettyAmount()
                }
                
                let positionOriginal = textField.beginningOfDocument
                if let amountTextFieldCursorPosition = textField.position(from: positionOriginal, offset: self.amountTextFieldCursorOffset) {
                    textField.selectedTextRange = textField.textRange(from: amountTextFieldCursorPosition, to: amountTextFieldCursorPosition)
                }
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.amountTextField {

            let currentText = textField.text ?? ""
            let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string) // new text
            
            if SetupManager.shared.isUserUsingDecimal {
                if replacementText.count > 21 {
                    // cant go more than 99 billions
                    return false
                }
            } else {
                if replacementText.count > 18 {
                    // cant go more than 99 billions
                    return false
                }
            }
            
            if replacementText.isValidDouble() {
                var cursorAdditionalOffset = 0
                // referensi set cursor
                // https://stackoverflow.com/questions/26284271/format-uitextfield-text-without-having-cursor-move-to-the-end/37031132
                if SetupManager.shared.isUserUsingDecimal {
                    // berarti ada extra 3 char ".00"
                    
                    // cek apakah ada decimal point dlm text
                    let numberFormatter = NumberFormatter()
                    numberFormatter.allowsFloats = true
                    let decimalSeparator = numberFormatter.decimalSeparator ?? "."
                    let split = replacementText.components(separatedBy: decimalSeparator)
                    
                    if string.isEmpty {
                        // deleting
                        if split.first!.count > 0 && split.first!.count % 4 == 0 {
                            cursorAdditionalOffset = -1
                        } else {
                            cursorAdditionalOffset = 0
                        }
                    } else {
                        // inserting
                        print("bzz replacement text count \(replacementText.count)")
                        if split.first!.count % 4 == 0 {
                            cursorAdditionalOffset = 2
                        } else {
                            cursorAdditionalOffset = 1
                        }
                    }
                } else {
                    // tanpa extra 3 char ".00"
                    if string.isEmpty {
                        // deleting
                        if replacementText.count % 4 == 0 {
                            cursorAdditionalOffset = -1
                        } else {
                            cursorAdditionalOffset = 0
                        }
                    } else {
                        // inserting
                        print("bzz replacement text count \(replacementText.count)")
                        if replacementText.count % 4 == 0 {
                            cursorAdditionalOffset = 2
                        } else {
                            cursorAdditionalOffset = 1
                        }
                    }
                }
                
                // key point utk set cursor
                self.amountTextFieldCursorOffset = range.location + cursorAdditionalOffset
                return true
            } else {
                if string.isEmpty { return true }
                return false
            }
        }
        
        return true
    }
}
