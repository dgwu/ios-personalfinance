//
//  ValidateOnboardingViewController.swift
//  PersonalFinance
//
//  Created by okky pribadi on 06/02/19.
//  Copyright © 2019 Daniel Gunawan. All rights reserved.
//

import UIKit

class ValidateOnboardingViewController: UIViewController {
    let setupManager = SetupManager.shared
    
    @IBOutlet weak var txtIncome: UITextField!
    @IBOutlet weak var txtSaving: UITextField!
    var amountTextFieldCursorOffset = 0
    
    @IBOutlet weak var viewSaving: UIView!
    
    @IBOutlet weak var btnOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnOutlet.layer.cornerRadius = 10
        viewSaving.layer.cornerRadius = 10
        txtIncome.delegate = self
        txtSaving.delegate = self
        
        txtIncome.addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingChanged)
        txtSaving.addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingChanged)
        
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func btnStart(_ sender: Any)
    {
        if let saving = txtSaving.text?.removePrettyNumberFormat(), let income = txtIncome.text?.removePrettyNumberFormat() {
            print("Masuk")
            setupManager.userMonthlySalary = income
            setupManager.userMonthlySaving = saving
//            self.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
        }else {
            print("Not a valid number")
        }
    }
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension ValidateOnboardingViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let amountString = textField.text ?? ""
        if amountString.isValidDouble() {
            if textField.text?.last != "." && textField.text?.first != "." && textField.text?.first != "0" {
                textField.text = amountString.removePrettyNumberFormat()?.prettyAmount()
            }
            
            let positionOriginal = textField.beginningOfDocument
            if let amountTextFieldCursorPosition = textField.position(from: positionOriginal, offset: self.amountTextFieldCursorOffset) {
                textField.selectedTextRange = textField.textRange(from: amountTextFieldCursorPosition, to: amountTextFieldCursorPosition)
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
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
                if split.first!.count % 4 == 0 {
                    cursorAdditionalOffset = 2
                } else {
                    cursorAdditionalOffset = 1
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
}
