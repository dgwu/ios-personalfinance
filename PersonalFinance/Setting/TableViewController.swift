//
//  MainSetting.swift
//  PersonalFinance
//
//  Created by okky pribadi on 08/01/19.
//  Copyright © 2019 Daniel Gunawan. All rights reserved.
//

import Foundation
import UIKit
import LocalAuthentication


enum BiometricType
{
    case none
    case touchId
    case faceId
}

class TableViewController: UITableViewController
{
    let setupManager = SetupManager.shared
    @IBOutlet weak var lblSalary: UILabel!
    @IBOutlet weak var lblSaving: UILabel!
    @IBOutlet weak var lblCurrency: UILabel!
    
    // for notification
    @IBOutlet weak var notifState: UISwitch!
    
    @IBOutlet weak var faceIdState: UISwitch!
    @IBOutlet weak var fingerPrintState: UISwitch!
    
    
    //for Decimal
    @IBOutlet weak var decimalState: UISwitch!
    @IBAction func actDecimal(_ sender: Any)
    {
        if (decimalState.isOn == true)
        {
            setupManager.isUserUsingDecimal = true
        }else
        {
            setupManager.isUserUsingDecimal = false
        }
    }
    
    @IBAction func actNotifState(_ sender: Any)
    {
        if (notifState.isOn == true)
        {
            setupManager.isUserAllowNotification = true
        }else
        {
            setupManager.isUserAllowNotification = false
        }
    }
    
    @IBAction func actionFaceId(_ sender: Any)
    {
        if (faceIdState.isOn == true)
        {
            setupManager.isUserUsingFaceLock = true
        }else
        {
            setupManager.isUserUsingFaceLock = false
        }
    }
    
    @IBAction func actionFingerPrint(_ sender: Any)
    {
        if (fingerPrintState.isOn == true)
        {
            setupManager.isUserUsingFingerLock = true
        }else
        {
            setupManager.isUserUsingFingerLock = false
        }
    }
    
    // buat check support face Id atau gak
    var isFaceIDSupported: Bool {
        if #available(iOS 11.0, *) {
            let localAuthenticationContext = LAContext()
            if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
                return localAuthenticationContext.biometryType == .faceID
            }
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAccount", let destination = segue.destination as? AccountViewController, let _ = tableView.indexPathForSelectedRow?.row
        {
            destination.title = "My Account"
        }
        else if segue.identifier == "currencyId", let destination = segue.destination as? CurrencyViewController
        {
            destination.title = "Currency"
            print ("masuk currency")
        }
        else if segue.identifier == "showCategory", let destination = segue.destination as? CategoryViewController
        {
            destination.title = "Category"
        }
        else if segue.identifier == "walletID", let destination = segue.destination as? WalletViewController
        {
            destination.title = "Wallet"
        }
    }
    
    
    func initialLoad()
    {
        print(isFaceIDSupported)
        
        lblSalary.text = "\(NumberFormatter.localizedString(from: NSNumber(value: setupManager.userMonthlySalary),     number: .decimal))"
        lblSaving.text = "\(NumberFormatter.localizedString(from: NSNumber(value: setupManager.userMonthlySaving), number: .decimal))"
        lblCurrency.text = setupManager.userDefaultCurrency

        notifState.isOn = setupManager.isUserAllowNotification
        decimalState.isOn = setupManager.isUserUsingDecimal
        faceIdState.isOn = setupManager.isUserUsingFaceLock
        fingerPrintState.isOn = setupManager.isUserUsingFingerLock
        
    }
    
    override func viewDidLoad()
    {
        initialLoad()
        super.viewDidLoad()
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        var rowHeight:CGFloat = 0.0
        
        if(indexPath.section == 0 && indexPath.row == 0){
            rowHeight = 123.0
        }
        else if(indexPath.section == 3 && indexPath.row == 0){
            if (isFaceIDSupported == false)
            {
                rowHeight = 0.0
            }else
            {
                rowHeight = 45.0
            }
        }else if(indexPath.section == 3 && indexPath.row == 1){
            if (isFaceIDSupported == true)
            {
                rowHeight = 0.0
            }else
            {
                rowHeight = 45.0
            }
        }
        else{
            rowHeight = 45.0
        }
        return rowHeight
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("selected  section is \(indexPath.section)")
        print("selected row is \(indexPath.row)")
        
        print("\(tableView.restorationIdentifier)")
        
        
        if (indexPath.section == 1 && indexPath.row == 0)
        {
            showInputDialog(title: "Monthly Salary",
                            subtitle: "Please enter your salary.",
                            actionTitle: "Save",
                            cancelTitle: "Cancel",
                            inputPlaceholder: "\(NumberFormatter.localizedString(from: NSNumber(value: setupManager.userMonthlySalary), number: .decimal))",
                            inputKeyboardType: .numberPad)
            { (input:String?) in
                print("The new number is \(input ?? "")")
               self.setupManager.userMonthlySalary = Double(input!) ?? 0
                self.initialLoad()
            }
        }
        if (indexPath.section == 1 && indexPath.row == 1)
        {
            showInputDialog(title: "Monthly Saving",
                            subtitle: "Please enter your Saving.",
                            actionTitle: "Save",
                            cancelTitle: "Cancel",
                            inputPlaceholder: "\(NumberFormatter.localizedString(from: NSNumber(value: setupManager.userMonthlySaving), number: .decimal))",
                            inputKeyboardType: .numberPad)
            { (input:String?) in
                print("The new number is \(input ?? "")")
                self.setupManager.userMonthlySaving = Double(input!) ?? 0
                self.initialLoad()
            }
        }
    }
}

extension UIViewController {
    func showInputDialog(title:String? = nil,
                         subtitle:String? = nil,
                         actionTitle:String? = "Add",
                         cancelTitle:String? = "Cancel",
                         inputPlaceholder:String? = nil,
                         inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        self.present(alert, animated: true, completion: nil)
    }
}



