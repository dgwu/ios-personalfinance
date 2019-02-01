//
//  SecurityViewController.swift
//  PersonalFinance
//
//  Created by okky pribadi on 24/01/19.
//  Copyright © 2019 Daniel Gunawan. All rights reserved.
//

import UIKit
import LocalAuthentication//
//class CustomTextField: UITextField {
//     func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
//        if action == "paste:" {
//            print("gak boleh Paste")
//            return false
//        }
//
//        return super.canPerformAction(action, withSender: sender)
//    }
//}

class SecurityViewController: UIViewController
{
    @IBOutlet weak var imageSecurity: UIImageView!
    @IBOutlet weak var lblMode: UILabel!
    
    let setupManager = SetupManager.shared
    
    @IBAction func btnClick(_ sender: Any)
    {
        handleFaceId()
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if (setupManager.isUserUsingFaceLock == true)
        {
            lblMode.text = "Requiring Attention Makes Face ID More Secure"
        }
        else if (setupManager.isUserUsingFingerLock == true)
        {
            lblMode.text = "Requiring Attention Makes Finger Print More Secure"
        }
        else
        {
                //perform segue ke halaman utama
        }

    }
    
    
    @objc fileprivate func handleFaceId()
    {
        let context = LAContext()
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "To have an access to apps, we need to check your faceid") { (wasSuccessful, error) in
                if wasSuccessful
                {
                    self.dismiss(animated: true, completion: nil)
                }
                else
                {
                    Alert.ShowBasic(title: "Incorrect credentials", msg: "Please try again", vc: self)
                }
            }
        }else
        {
            Alert.ShowBasic(title: "FaceID Not Configured", msg: "Please Go To settigs", vc: self)
        }
        
    }
    
    
    
    
}
