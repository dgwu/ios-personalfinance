//
//  ValidateOnboardingViewController.swift
//  PersonalFinance
//
//  Created by okky pribadi on 06/02/19.
//  Copyright © 2019 Daniel Gunawan. All rights reserved.
//

import UIKit

class ValidateOnboardingViewController: UIViewController,UITextFieldDelegate {
    let setupManager = SetupManager.shared
    
    @IBOutlet weak var txtIncome: UITextField!
    @IBOutlet weak var txtSaving: UITextField!
    
    @IBOutlet weak var viewSaving: UIView!
    
    @IBOutlet weak var btnOutlet: UIButton!
  
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
            let amountString = textField.text ?? ""
            if amountString.isValidDouble() {
                textField.text = amountString.removePrettyNumberFormat()?.prettyAmount()
            }
       
    }
    


    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // User pressed the delete-key to remove a character, this is always valid, return true to allow change
            if string.isEmpty { return true }

            let currentText = textField.text ?? ""
            let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)

            return replacementText.isValidDouble()
       
    }
//
//    @objc func textFieldValDidChange(_ textField: UITextField)
//    {
//       let formatter = NumberFormatter()
//        formatter.numberStyle = NumberFormatter.Style.decimal
//        if textField.text!.count >= 1 {
//        let number = Double(textField.text!.replacingOccurrences(of: ".", with: ""))
//        let result = formatter.string(from: NSNumber(value: number!))
//        textField.text = result!
//        }
//    }
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        txtIncome.addTarget(self, action: #selector(textFieldValDidChange), for: .editingChanged)
//         txtSaving.addTarget(self, action: #selector(textFieldValDidChange), for: .editingChanged)
        btnOutlet.layer.cornerRadius = 10
        viewSaving.layer.cornerRadius = 10
        txtIncome.delegate = self
        txtSaving.delegate = self
       
        self.hideKeyboardWhenTappedAround()
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
