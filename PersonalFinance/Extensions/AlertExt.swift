//
//  AlertExt.swift
//  PersonalFinance
//
//  Created by okky pribadi on 25/01/19.
//  Copyright © 2019 Daniel Gunawan. All rights reserved.
//

import UIKit
import Foundation
class Alert
{
    class func ShowBasic(title: String, msg: String, vc: UIViewController)
    {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        vc.present(alert,animated: true)
    }
}
