//
//  String+Double.swift
//  PersonalFinance
//
//  Created by Daniel Gunawan on 14/02/19.
//  Copyright © 2019 Daniel Gunawan. All rights reserved.
//

import Foundation

extension String {
    // credit to
    // https://www.markusbodner.com/2017/06/20/how-to-verify-and-limit-decimal-number-inputs-in-ios-with-swift/
    // modified
    
    func isValidDouble() -> Bool {
        let maxDecimalPlaces:Int = 2
        // Use NumberFormatter to check if we can turn the string into a number
        // and to get the locale specific decimal separator.
        let formatter = NumberFormatter()
        formatter.allowsFloats = true // Default is true, be explicit anyways
        let decimalSeparator = formatter.decimalSeparator ?? "."  // Gets the locale specific decimal separator. If for some reason there is none we assume "." is used as separator.
        
        // modification part
        let thousandSeparator = formatter.groupingSeparator ?? ","
        let withoutThousandSeparator = self.replacingOccurrences(of: thousandSeparator, with: "")
        
        // Check if we can create a valid number. (The formatter creates a NSNumber, but
        // every NSNumber is a valid double, so we're good!)
        if formatter.number(from: withoutThousandSeparator) != nil {
            // Split our string at the decimal separator
            let split = self.components(separatedBy: decimalSeparator)
            
            // Depending on whether there was a decimalSeparator we may have one
            // or two parts now. If it is two then the second part is the one after
            // the separator, aka the digits we care about.
            // If there was no separator then the user hasn't entered a decimal
            // number yet and we treat the string as empty, succeeding the check
            let decimalDigits = split.count == 2 ? split.last ?? "" : ""
            
            // Finally check if we're <= the allowed digits
            return decimalDigits.count <= maxDecimalPlaces    // TODO: Swift 4.0 replace with digits.count, YAY!
        }
        
        return false // couldn't turn string into a valid number
    }
    
    func removePrettyNumberFormat() -> Double? {
        let formatter = NumberFormatter()
        formatter.allowsFloats = true // Default is true, be explicit anyways
        
        let thousandSeparator = formatter.groupingSeparator ?? ","
        let withoutThousandSeparator = self.replacingOccurrences(of: thousandSeparator, with: "")
        return formatter.number(from: withoutThousandSeparator)?.doubleValue
    }
}

extension Double {
    func prettyAmount() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
//        formatter.groupingSeparator = ""
        formatter.minimumFractionDigits = SetupManager.shared.isUserUsingDecimal ? 2 : 0
        formatter.maximumFractionDigits = SetupManager.shared.isUserUsingDecimal ? 2 : 0
        
        return formatter.string(from: NSNumber(value: self))!
    }
}
