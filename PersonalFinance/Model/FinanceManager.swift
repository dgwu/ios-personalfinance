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
}


// handle transaction
extension FinanceManager {
    public func insertTransaction(date: Date, amount: Double, type: TransactionType, category: Category, sourceWallet: Wallet) {
        if type == .expense {
            insertExpense(date: date, amount: amount, category: category, wallet: sourceWallet)
        } else {
            insertIncome(date: date, amount: amount, category: category, wallet: sourceWallet)
        }
    }
    
    public func insertExpense(date: Date, amount: Double, category: Category, wallet: Wallet) {
        let newTransaction = Transaction(context: self.objectContext)
        newTransaction.createdDate = Date()
        newTransaction.transactionType = Int16(TransactionType.expense.rawValue)
        newTransaction.transactionDate = date
        newTransaction.category = category
        newTransaction.amount = amount
        newTransaction.sourceWallet = wallet
        
        do {
            try self.objectContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func insertIncome(date: Date, amount: Double, category: Category, wallet: Wallet) {
        let newTransaction = Transaction(context: self.objectContext)
        newTransaction.createdDate = Date()
        newTransaction.transactionType = Int16(TransactionType.income.rawValue)
        newTransaction.transactionDate = date
        newTransaction.category = category
        newTransaction.amount = amount
        newTransaction.sourceWallet = wallet
        
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
    public func getExpenseResultController(fromDate: Date?, toDate: Date?) -> NSFetchedResultsController<Transaction> {
        let fetchRequest = NSFetchRequest<Transaction>(entityName:"Transaction")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "transactionDate", ascending:false)]
        fetchRequest.predicate = NSPredicate(format: "transactionType == %d", TransactionType.expense.rawValue)
        
        if let fromDate = fromDate, let toDate = toDate {
            fetchRequest.predicate = NSPredicate(format: "transactionDate >= %@ && transactionDate <= %@", argumentArray: [fromDate, toDate])
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
        fetchRequest.predicate = NSPredicate(format: "transactionType == %d", TransactionType.income.rawValue)
        
        if let fromDate = fromDate, let toDate = toDate {
            fetchRequest.predicate = NSPredicate(format: "transactionDate >= %@ && transactionDate <= %@", argumentArray: [fromDate, toDate])
        }
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: self.objectContext,
                                                    sectionNameKeyPath: nil, cacheName: nil)
        
        
        return controller
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
