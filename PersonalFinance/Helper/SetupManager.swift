//
//  SetupManager.swift
//  PersonalFinance
//
//  Created by Daniel Gunawan on 09/01/19.
//  Copyright © 2019 Daniel Gunawan. All rights reserved.
//

import Foundation
class SetupManager {
    static let shared = SetupManager()
    
    // setter and getter for userDefaults
    public var isExpenseCategoriesPreloaded = UserDefaults.standard.bool(forKey: "expenseCategoriesPreloaded") {
        didSet {
            UserDefaults.standard.set(isExpenseCategoriesPreloaded, forKey: "expenseCategoriesPreloaded")
        }
    }
    
    public var isIncomeCategoriesPreloaded = UserDefaults.standard.bool(forKey: "incomeCategoriesPreloaded") {
        didSet {
            UserDefaults.standard.set(isIncomeCategoriesPreloaded, forKey: "incomeCategoriesPreloaded")
        }
    }
    
    public var isWalletsPreloaded = UserDefaults.standard.bool(forKey: "walletsPreloaded") {
        didSet {
            UserDefaults.standard.set(isWalletsPreloaded, forKey: "walletsPreloaded")
        }
    }
    
    public var isSimulationPreloaded = UserDefaults.standard.bool(forKey: "simulationPreloaded") {
        didSet {
            UserDefaults.standard.set(isWalletsPreloaded, forKey: "simulationPreloaded")
        }
    }
    
    
    // setting page
    public var userMonthlySalary = UserDefaults.standard.double(forKey: "userMonthlySalary") {
        didSet {
            UserDefaults.standard.set(userMonthlySalary, forKey: "userMonthlySalary")
        }
    }
    
    public var userMonthlySavingIsPercentage = UserDefaults.standard.bool(forKey: "userMonthlySavingIsPercentage") {
        didSet {
            UserDefaults.standard.set(userMonthlySavingIsPercentage, forKey: "userMonthlySavingIsPercentage")
        }
    }
    
    public var userMonthlySaving = UserDefaults.standard.double(forKey: "userMonthlySaving") {
        didSet {
            UserDefaults.standard.set(userMonthlySaving, forKey: "userMonthlySaving")
        }
    }
    
    public var isUserAllowNotification = UserDefaults.standard.bool(forKey: "isUserAllowNotification") {
        didSet {
            UserDefaults.standard.set(isUserAllowNotification, forKey: "isUserAllowNotification")
        }
    }
    
    public var isUserUsingDecimal = UserDefaults.standard.bool(forKey: "isUserUsingDecimal") {
        didSet {
            UserDefaults.standard.set(isUserUsingDecimal, forKey: "isUserUsingDecimal")
        }
    }
    
    public var isUserUsingFaceLock = UserDefaults.standard.bool(forKey: "isUserUsingFaceLock") {
        didSet {
            UserDefaults.standard.set(isUserUsingFaceLock, forKey: "isUserUsingFaceLock")
        }
    }
    
    public var isUserUsingFingerLock = UserDefaults.standard.bool(forKey: "isUserUsingFingerLock") {
        didSet {
            UserDefaults.standard.set(isUserUsingFingerLock, forKey: "isUserUsingFingerLock")
        }
    }
    
    public var isNeedToAttemptSecurityCheck = UserDefaults.standard.bool(forKey: "isNeedToAttemptSecurityCheck") {
        didSet {
            UserDefaults.standard.set(isNeedToAttemptSecurityCheck, forKey: "isNeedToAttemptSecurityCheck")
        }
    }
    
    public var userDefaultCurrency = UserDefaults.standard.string(forKey: "userDefaultCurrency") ?? "" {
        didSet {
            UserDefaults.standard.set(userDefaultCurrency ,forKey: "userDefaultCurrency")
        }
    }
    
    public var userDefaultCurrencyName = UserDefaults.standard.string(forKey: "userDefaultCurrencyName") ?? "" {
        didSet {
            UserDefaults.standard.set(userDefaultCurrency ,forKey: "userDefaultCurrencyName")
        }
    }
    
    public var appMigrateVersion = UserDefaults.standard.integer(forKey: "appMigrateVersion") {
        didSet {
            UserDefaults.standard.set(appMigrateVersion ,forKey: "appMigrateVersion")
        }
    }
}
