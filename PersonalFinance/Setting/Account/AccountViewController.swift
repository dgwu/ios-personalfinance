//
//  AccountViewController.swift
//  PersonalFinance
//
//  Created by okky pribadi on 14/01/19.
//  Copyright © 2019 Daniel Gunawan. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {
    
    let setupManager = SetupManager.shared
    var MyAccount = "My Account"

    @IBOutlet weak var groupViewHeader: UIView!
    @IBOutlet weak var viewProfile: UIView!
    @IBOutlet weak var lblJudul: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblJudul.text = MyAccount
        groupViewHeader.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
        
        if (setupManager.isUserAllowNotification == true)
        {
            viewProfile.isHidden = true
            groupViewHeader.isHidden = false
        }else
        {
            viewProfile.isHidden = false
            groupViewHeader.isHidden = true
        }
        
        
    }

}
