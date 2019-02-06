//
//  FinanceManager+Budget.swift
//  PersonalFinance
//
//  Created by Daniel Gunawan on 06/02/19.
//  Copyright © 2019 Daniel Gunawan. All rights reserved.
//

import Foundation
import CoreData

extension FinanceManager {
    
    // get remaining budget amount
    public func monthlyRemainingBudget() -> Double {
        let startOfMonth = Date().startOfMonth()
        let endOfMonth = Date().endOfMonth().endOfDay
        
        let monthlySalary = SetupManager.shared.userMonthlySalary
        let savingIsPercentage = SetupManager.shared.userMonthlySavingIsPercentage
        let savingSettingAmount = SetupManager.shared.userMonthlySaving
        var savingAmount: Double = 0
        var remainingBudget: Double = 0
        
        if savingIsPercentage {
            savingAmount = monthlySalary * savingSettingAmount / 100
        } else {
            savingAmount = savingSettingAmount
        }
        remainingBudget = monthlySalary - savingAmount
        
        // calculate running transaction
        let transactionSummaryInPeriod = self.transactionSummaryInPeriod(fromDate: startOfMonth, toDate: endOfMonth)
        let totalExpenseInPeriod = transactionSummaryInPeriod.totalExpense
        let totalIncomeInPeriod = transactionSummaryInPeriod.totalIncome
        
        // kalo saving nya persentase berarti income lebihnya dijadikan persentase sebelum ditambah ke budget
        var excessIncome: Double = 0
        if totalIncomeInPeriod > monthlySalary {
            excessIncome = totalIncomeInPeriod - monthlySalary
            
            if savingIsPercentage {
                remainingBudget += (excessIncome - (excessIncome * savingSettingAmount / 100))
            } else {
                remainingBudget += excessIncome
            }
        }
        
        
        return remainingBudget - totalExpenseInPeriod
    }
    
    // untuk menentukan limit budget mrk utk tiap kategori:
    // great, ok, worst
    public func monthlyBudgetMeter() -> (great: Double, ok: Double, worst: Double) {
        let daysInMonth = Double(exactly: Date().getDaysInMonth()) ?? 30
        let currentDayNumber = Double(exactly: Date().getCurrentDayNumber()) ?? 1
        
        let monthlySalary = SetupManager.shared.userMonthlySalary
        let monthlySaving = SetupManager.shared.userMonthlySaving
        let monthlyBudget = monthlySalary - monthlySaving
        let dailyBudget = monthlyBudget / daysInMonth
        
        var greatMeter: Double = dailyBudget * currentDayNumber - (2 * dailyBudget)
        if greatMeter < 0 {
            greatMeter = 0
        }
        
        let okMeter: Double = dailyBudget * currentDayNumber
        let worstMeter: Double = dailyBudget * currentDayNumber + (2 * dailyBudget)
        
        return (greatMeter, okMeter, worstMeter)
    }
}
