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
    
    @IBOutlet weak var viewSaving: UIView!
    
    @IBOutlet weak var btnOutlet: UIButton!
  
    
    
    @IBAction func btnStart(_ sender: Any)
    {
        if let saving = Double(txtSaving.text!), let income = Double(txtIncome.text!) {
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
        btnOutlet.layer.cornerRadius = 10
        viewSaving.layer.cornerRadius = 10
        
       
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
