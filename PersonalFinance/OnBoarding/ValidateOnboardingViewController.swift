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
        let saving: Double? = Double(txtSaving.text!)
        let income: Double? = Double(txtIncome.text!)
        if(saving! >= 0 && income! >= 0)
        {
            
            print("Masuk")
            setupManager.userMonthlySaving = saving!
            setupManager.userMonthlySalary = income!
            
           
        }else
        {
            print("alert input")
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
