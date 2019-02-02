//
//  SecurityViewController.swift
//  PersonalFinance
//
//  Created by okky pribadi on 24/01/19.
//  Copyright © 2019 Daniel Gunawan. All rights reserved.
//

import UIKit
import LocalAuthentication

class SecurityViewController: UIViewController
{
    @IBOutlet weak var imageSecurity: UIImageView!
    @IBOutlet weak var lblMode: UILabel!
    
    let setupManager = SetupManager.shared
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleFaceId))
        self.view.addGestureRecognizer(tapRecognizer)
        
        if (setupManager.isUserUsingFaceLock == true)
        {
            lblMode.text = "Face ID to open app"
        }
        else if (setupManager.isUserUsingFingerLock == true)
        {
            lblMode.text = "Touch ID to open app"
        }
        
        self.handleFaceId()
    }
    
    @objc fileprivate func handleFaceId()
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
                    self.setupManager.isNeedToAttemptSecurityCheck = false
                    self.dismiss(animated: true, completion: nil)
                }
                else
                {
                    Alert.ShowBasic(title: "Incorrect credentials", msg: "Please try again", vc: self)
                }
            }
        }else
        {
            Alert.ShowBasic(title: "Face ID/Touch ID Not Configured", msg: "Please Go To settigs", vc: self)
        }
        
    }
    
}
