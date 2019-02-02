//
//  ViewController.swift
//  PersonalFinance
//
//  Created by Daniel Gunawan on 11/12/18.
//  Copyright © 2018 Daniel Gunawan. All rights reserved.
//

import UIKit

class ViewController: UITabBarController {
    let setupManager = SetupManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // pop up security check
        if setupManager.isUserUsingFingerLock || setupManager.isUserUsingFaceLock {
            
            print("use security check")
            if setupManager.isNeedToAttemptSecurityCheck {
                let securityStoryboard = UIStoryboard(name: "Security", bundle: nil)
                let securityController = securityStoryboard.instantiateInitialViewController() as! SecurityViewController
                
                self.present(securityController, animated: false, completion: nil)
            }
        } else {
            print("did not use security check")
        }
    }
}

