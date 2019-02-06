//
//  FinanceManager+Transactions.swift
//  PersonalFinance
//
//  Created by Daniel Gunawan on 06/02/19.
//  Copyright © 2019 Daniel Gunawan. All rights reserved.
//

import Foundation
import CoreData

extension FinanceManager {
    // MARK: Common Transaction Getter
    
    // dapatin total income dan expense dalam satuan waktu
    public func transactionSummaryInPeriod(fromDate: Date, toDate: Date) -> (totalIncome: Double, totalExpense: Double) {
        var totalExpenseInPeriod: Double = 0
        var totalIncomeInPeriod: Double = 0
        
        if let monthlyTransactions = self.getTransactionResult(fromDate: fromDate, toDate: toDate) {
            for transaction in monthlyTransactions {
                if transaction.transactionType == Int16(TransactionType.expense.rawValue) {
                    totalExpenseInPeriod += transaction.amount
                }
                if transaction.transactionType == Int16(TransactionType.income.rawValue) {
                    totalIncomeInPeriod += transaction.amount
                }
            }
        }
        
        return (totalIncomeInPeriod, totalExpenseInPeriod)
    }
    
    // MARK: Transaction Handling
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
    
    
    // MARK : Transaction Record Controller
    
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
