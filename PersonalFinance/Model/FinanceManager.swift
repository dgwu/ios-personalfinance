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
