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

class SettingTableViewController: UITableViewController
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
        initialLoad()
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
            let context = LAContext()
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
            {
                var localizedReason = ""
                
                switch context.biometryType {
                case .none:
                    print("handle face id type none")
                case .touchID:
                    print("handle face id type touch id")
                    localizedReason = "Protect your data with Touch ID."
                case .faceID:
                    print("handle face id type face id")
                    localizedReason = "Protect your data with Face ID."
                }
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: localizedReason) { (wasSuccessful, error) in
                    if wasSuccessful
                    {
                        self.setupManager.isUserUsingFaceLock = true
                        self.setupManager.isNeedToAttemptSecurityCheck = false
                    }
                    else
                    {
                        Alert.ShowBasic(title: "Incorrect credentials", msg: "Please try again", vc: self)
                        DispatchQueue.main.async {
//                            self.faceIdState.isOn = false
                            self.faceIdState.setOn(false, animated: true)
                        }
                        
                    }
                }
            } else {
                Alert.ShowBasic(title: "Face ID/Touch ID Not Configured", msg: "Please Go To settings", vc: self)
//                self.faceIdState.isOn = false
                self.faceIdState.setOn(false, animated: true)
            }
        }else
        {
            setupManager.isUserUsingFaceLock = false
//            print("bzz ketika off")
//            if setupManager.isUserUsingFaceLock { // karena sdh pakai security, berarti pas matiin security perlu verifikasi face id juga
//
//                // do face id permission check
//                let context = LAContext()
//                if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
//                {
//                    print("bzz ketika off cek awal")
//                    var localizedReason = ""
//
//                    switch context.biometryType {
//                    case .none:
//                        print("handle face id type none")
//                    case .touchID:
//                        print("handle face id type touch id")
//                        localizedReason = "Protect your data with Touch ID."
//                    case .faceID:
//                        print("handle face id type face id")
//                        localizedReason = "Protect your data with Face ID."
//                    }
//
//                    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: localizedReason) { (wasSuccessful, error) in
//                        print("bzz ketika off cek dalam")
//                        if wasSuccessful
//                        {
//                            print("bzz ketika off berhasil")
//                            self.setupManager.isUserUsingFaceLock = false
//                        }
//                        else
//                        {
//                            print("bzz ketika off gagal")
//                            Alert.ShowBasic(title: "Incorrect credentials", msg: "Please try again", vc: self)
//                            DispatchQueue.main.async {
////                                self.faceIdState.isOn = true
//                                self.faceIdState.setOn(true, animated: true)
//                            }
//
//                        }
//                    }
//                } else {
//                    self.setupManager.isUserUsingFaceLock = false
//                }
//            } else {
//                setupManager.isUserUsingFaceLock = false
//            }
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
        if BiometricHelper.biometricType() == .face {
            return true
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAccount", let destination = segue.destination as? AccountViewController, let _ = tableView.indexPathForSelectedRow?.row
        {
            destination.title = "My Account"
        }
//        else if segue.identifier == "showSalary", let destination = segue.destination as? SalaryViewController
//        {
//             destination.title = "Salary"
//        }
        else if segue.identifier == "currencyId", let destination = segue.destination as? CurrencyViewController
        {
            destination.title = "Currency"
            destination.delegate = self
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
    
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
       guard let footer = view as? UITableViewHeaderFooterView else { return }
        footer.textLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        footer.textLabel?.textAlignment = .right
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {
            return
        }
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 25)
//        header.textLabel?.font = ÷
    }
    
    
    //defaults.setObject("Coding Explorer", forKey: "userNameKey")
    func initialLoad()
    {
        lblSalary.text = GeneralHelper.displayAmount(amount: setupManager.userMonthlySalary)
        lblSaving.text = GeneralHelper.displayAmount(amount: setupManager.userMonthlySaving)

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
        self.title = "Settings"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.3568627451, green: 0.5921568627, blue: 0.8392156863, alpha: 1)
        navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.3568627451, green: 0.5921568627, blue: 0.8392156863, alpha: 1)
    
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        var rowHeight:CGFloat = 0.0
        if(indexPath.section == 0 && indexPath.row == 0)
        {// hide profile Detail
            rowHeight = 0
        }
        else if(indexPath.section == 0 && indexPath.row == 1){
            // Hide gambar profile
            //rowHeight = 123 // was 123
            rowHeight = 0
        }else if(indexPath.section == 0 && indexPath.row == 4){
            // Hide gambar profile
            //rowHeight = 123 // was 123
            rowHeight = 0
        }else if(indexPath.section == 0 && indexPath.row == 5){
            // Hide gambar profile
            //rowHeight = 123 // was 123
            rowHeight = 0
        }else if(indexPath.section == 1 && indexPath.row == 0)
         {// buat hide notification
                rowHeight = 0.0
        }else if(indexPath.section == 1 && indexPath.row == 2)
        {// buat hide currency
            rowHeight = 0.0
        }else if(indexPath.section == 3 && indexPath.row == 0)
        {// buat hide currency
            rowHeight = 0.0
        }else if(indexPath.section == 2 && indexPath.row == 0){
            if (BiometricHelper.biometricType() == .face)
            {
                rowHeight = 45.0
            }else
            {
                rowHeight = 0.0
            }
        }
        else if(indexPath.section == 2 && indexPath.row == 1){
            if (BiometricHelper.biometricType() == .touch)
            {
                rowHeight = 45.0
            }else
            {
                rowHeight = 0.0
            }
        }
        else{
            rowHeight = 45.0
        }
        return rowHeight
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if (indexPath.section == 0 && indexPath.row == 2)
        {
            showInputDialog(title: "Monthly Salary",
                            subtitle: "Please enter your salary.",
                            actionTitle: "Save",
                            cancelTitle: "Cancel",
                            inputPlaceholder: "\(NumberFormatter.localizedString(from: NSNumber(value: setupManager.userMonthlySalary), number: .decimal))",
                            inputKeyboardType: .numberPad)
            { (input:String?) in
                print("The new number is \(input ?? "")")
                self.setupManager.userMonthlySalary = (input! as NSString).doubleValue  ?? 0
                self.initialLoad()
            }
        }
        if (indexPath.section == 0 && indexPath.row == 3)
        {
            showInputDialog(title: "Monthly Saving",
                            subtitle: "Please enter your Saving.",
                            actionTitle: "Save",
                            cancelTitle: "Cancel",
                            inputPlaceholder: "\(NumberFormatter.localizedString(from: NSNumber(value: setupManager.userMonthlySaving), number: .decimal))",
                            inputKeyboardType: .numberPad)
            { (input:String?) in
                print("The new number is \(input ?? "")")
                self.setupManager.userMonthlySaving = (input! as NSString).doubleValue  ?? 0
                self.initialLoad()
            }
        }
    }
}

extension SettingTableViewController: CurrencyViewControllerDelegate {
    func updateCurrency() {
        self.lblCurrency.text = setupManager.userDefaultCurrency
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

