//
//  GeneralHelper.swift
//  PersonalFinance
//
//  Created by Daniel Gunawan on 05/02/19.
//  Copyright © 2019 Daniel Gunawan. All rights reserved.
//

import Foundation
class GeneralHelper {
    
    static func displayAmount(amount: Double) -> String {
        let locale = Locale.current
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = SetupManager.shared.isUserUsingDecimal ? 2 : 0
        formatter.maximumFractionDigits = SetupManager.shared.isUserUsingDecimal ? 2 : 0
        
        return locale.currencySymbol! + " " + formatter.string(from: NSNumber(value: amount))!
    }
}
