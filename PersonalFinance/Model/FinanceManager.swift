//
//  FinanceManager.swift
//  PersonalFinance
//
//  Created by Daniel Gunawan on 09/01/19.
//  Copyright © 2019 Daniel Gunawan. All rights reserved.
//

import UIKit
import CoreData

class FinanceManager {
    static let shared = FinanceManager()
    
    lazy var objectContext: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            //This should never happen
            return NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        }
        appDelegate.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        return appDelegate.persistentContainer.viewContext
    }()
    
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
        var totalExpenseInPeriod: Double = 0
        var totalIncomeInPeriod: Double = 0
        
        if let monthlyTransactions = self.getTransactionResult(fromDate: startOfMonth, toDate: endOfMonth) {
            for transaction in monthlyTransactions {
                if transaction.transactionType == Int16(TransactionType.expense.rawValue) {
                    totalExpenseInPeriod += transaction.amount
                }
                if transaction.transactionType == Int16(TransactionType.income.rawValue) {
                    totalIncomeInPeriod += transaction.amount
                }
            }
        }
        
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
        
        
        return remainingBudget
    }
    
    public func walletList() -> [Wallet]? {
        let walletFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Wallet")
        let predicate = NSPredicate(format: "isActive == %@", NSNumber(value: true))
        walletFetch.predicate = predicate
        
        do {
            let result = try objectContext.fetch(walletFetch) as! [Wallet]
            return result
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    // for test purposes
    public func defaultWallet() -> Wallet? {
        let walletFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Wallet")
        
        do {
            let result = try objectContext.fetch(walletFetch) as! [Wallet]
            if let firstWallet = result.first {
                return firstWallet
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    public func insertWallet(desc: String, openDate: Date, initialAmount: Double, iconName: String?, colorCode: String?) {
        let newWallet = Wallet(context: self.objectContext)
        newWallet.desc = desc
        newWallet.createdDate = openDate
        newWallet.initialAmount = initialAmount
        newWallet.colorCode = colorCode
        newWallet.iconName = iconName
        newWallet.isActive = true
        
        do {
            try self.objectContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func categoryList(type: CategoryType) -> [Category]? {
        let categoryFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        // filter parent category only
        let predicate = NSPredicate(format: "(parent == nil || parent.@count = 0) && type=%d", type.rawValue)
        categoryFetch.predicate = predicate
        categoryFetch.sortDescriptors = [NSSortDescriptor(key: "orderNumber", ascending:true)]
        do {
            let result = try objectContext.fetch(categoryFetch) as! [Category]
            return result
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    // for test purposes
    public func defaultCategory() -> Category? {
        let categoryFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        
        do {
            let result = try objectContext.fetch(categoryFetch) as! [Category]
            if let firstCategory = result.first {
                return firstCategory
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    public func insertCategory(categoryType: CategoryType, desc: String, iconName: String?, colorCode: String?) {
        let newCategory = Category(context: self.objectContext)
        newCategory.type = Int16(categoryType.rawValue)
        newCategory.desc = desc
        newCategory.iconName = iconName
        newCategory.colorCode = colorCode
        
        do {
            try self.objectContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}


// handle transaction
extension FinanceManager {
    public func insertTransaction(date: Date, amount: Double, type: TransactionType, category: Category, desc: String?, sourceWallet: Wallet?, benefWallet: Wallet? = nil) {
        if type == .expense {
            guard let sourceWallet = sourceWallet else {return}
            insertExpense(date: date, amount: amount, category: category, wallet: sourceWallet, desc: desc)
        } else {
            guard let benefWallet = benefWallet else {return}
            insertIncome(date: date, amount: amount, category: category, wallet: benefWallet, desc: desc)
        }
    }
    
    public func insertExpense(date: Date, amount: Double, category: Category, wallet: Wallet, desc: String?) {
        let newTransaction = Transaction(context: self.objectContext)
        newTransaction.createdDate = Date()
        newTransaction.transactionType = Int16(TransactionType.expense.rawValue)
        newTransaction.transactionDate = date
        newTransaction.category = category
        newTransaction.amount = amount
        newTransaction.sourceWallet = wallet
        newTransaction.desc = desc
        
        do {
            try self.objectContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func insertIncome(date: Date, amount: Double, category: Category, wallet: Wallet, desc: String?) {
        let newTransaction = Transaction(context: self.objectContext)
        newTransaction.createdDate = Date()
        newTransaction.transactionType = Int16(TransactionType.income.rawValue)
        newTransaction.transactionDate = date
        newTransaction.category = category
        newTransaction.amount = amount
        newTransaction.beneficiaryWallet = wallet
        newTransaction.desc = desc
        
        do {
            try self.objectContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
}


// handle getter
extension FinanceManager {
    /**
     Get expense only in defined time frame
     */
    public func getExpenseResultController(fromDate: Date?, toDate: Date?, take: Int? = nil) -> NSFetchedResultsController<Transaction> {
        let fetchRequest = NSFetchRequest<Transaction>(entityName:"Transaction")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "transactionDate", ascending:false)]
        
        var predicates = [NSPredicate(format: "transactionType == %d", TransactionType.expense.rawValue)]
        
        if let fromDate = fromDate, let toDate = toDate {
            predicates.append(NSPredicate(format: "transactionDate >= %@ && transactionDate <= %@", argumentArray: [fromDate, toDate]))
        }
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        if let take = take {
            fetchRequest.fetchLimit = take
        }
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: self.objectContext,
                                                    sectionNameKeyPath: nil, cacheName: nil)
        
        return controller
    }
    
    /**
     Get income only in defined time frame
     */
    public func getIncomeResultController(fromDate: Date?, toDate: Date?) -> NSFetchedResultsController<Transaction> {
        let fetchRequest = NSFetchRequest<Transaction>(entityName:"Transaction")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "transactionDate", ascending:false)]
        
        var predicates = [NSPredicate(format: "transactionType == %d", TransactionType.income.rawValue)]
        if let fromDate = fromDate, let toDate = toDate {
            predicates.append(NSPredicate(format: "transactionDate >= %@ && transactionDate <= %@", argumentArray: [fromDate, toDate]))
        }
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: self.objectContext,
                                                    sectionNameKeyPath: nil, cacheName: nil)
        
        
        return controller
    }
    
    public func getTransactionResult(fromDate: Date?, toDate: Date?) -> [Transaction]? {
        let fetchRequest = NSFetchRequest<Transaction>(entityName:"Transaction")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "transactionDate", ascending:false)]
        
        if let fromDate = fromDate, let toDate = toDate {
            fetchRequest.predicate = NSPredicate(format: "transactionDate >= %@ && transactionDate <= %@", argumentArray: [fromDate, toDate])
        }
        
        do {
            let result = try objectContext.fetch(fetchRequest)
            return result
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    /**
     Get Both expense and income in defined time frame
     */
    public func getTransactionResultController(fromDate: Date?, toDate: Date?) -> NSFetchedResultsController<Transaction> {
        let fetchRequest = NSFetchRequest<Transaction>(entityName:"Transaction")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "transactionDate", ascending:false)]
        
        if let fromDate = fromDate, let toDate = toDate {
            fetchRequest.predicate = NSPredicate(format: "transactionDate >= %@ && transactionDate <= %@", argumentArray: [fromDate, toDate])
        }
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: self.objectContext,
                                                    sectionNameKeyPath: nil, cacheName: nil)
        
        
        return controller
    }
}
