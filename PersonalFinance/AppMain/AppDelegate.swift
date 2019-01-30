//
//  AppDelegate.swift
//  PersonalFinance
//
//  Created by Daniel Gunawan on 11/12/18.
//  Copyright © 2018 Daniel Gunawan. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        preloadWallets()
        preloadIncomeCategory()
        preloadExpenseCategory()
        preloadSimulationData()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {	
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Preload Data
    private func preloadWallets() {
        let setupManager = SetupManager.shared
        
        if !setupManager.isWalletsPreloaded {
            guard let urlPath = Bundle.main.url(forResource: "DefaultWallets", withExtension: "plist") else {
                return
            }
            
            let backgroundContext = persistentContainer.newBackgroundContext()
            persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
            
            backgroundContext.perform {
                do {
                    if let arrayOfWallets = NSArray(contentsOf: urlPath) as? [Any] {
                        
                        for wallet in arrayOfWallets {
                            if let wallet = wallet as? [String:String] {
                                let newWallet = Wallet(context: backgroundContext)
                                newWallet.colorCode = wallet["colorCode"]
                                newWallet.desc = wallet["desc"]
                                newWallet.iconName = wallet["iconName"]
                                newWallet.initialAmount = 0
                                newWallet.isActive = true
                                newWallet.createdDate = Date()
                            }
                        }
                        
                        try backgroundContext.save()
                        
                        setupManager.isWalletsPreloaded = true
                    }
                    print("Successfully preloaded wallet")
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func preloadIncomeCategory() {
        let setupManager = SetupManager.shared
        
        if !setupManager.isIncomeCategoriesPreloaded {
            guard let urlPath = Bundle.main.url(forResource: "DefaultIncomeCategories", withExtension: "plist") else {
                return
            }
            
            let backgroundContext = persistentContainer.newBackgroundContext()
            persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
            
            backgroundContext.perform {
                do {
                    if let arrayOfCategories = NSArray(contentsOf: urlPath) as? [Any] {
                        
                        for category in arrayOfCategories {
                            if let category = category as? [String:String] {
                                let newMainCategory = Category(context: backgroundContext)
                                newMainCategory.desc = category["desc"]
                                newMainCategory.iconName = category["iconName"]
                                newMainCategory.colorCode = category["colorCode"]
                                newMainCategory.type = Int16(CategoryType.income.rawValue)
                            }
                        }
                        
                        try backgroundContext.save()
                        
                        setupManager.isIncomeCategoriesPreloaded = true
                    }
                    print("Successfully preloaded income category")
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func preloadExpenseCategory() {
        let setupManager = SetupManager.shared
        
        if !setupManager.isExpenseCategoriesPreloaded {
            guard let urlPath = Bundle.main.url(forResource: "DefaultExpenseCategories", withExtension: "plist") else {
                return
            }
            
            let backgroundContext = persistentContainer.newBackgroundContext()
            persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
            
            backgroundContext.perform {
                do {
                    if let arrayOfCategories = NSArray(contentsOf: urlPath) as? [Any] {
                        
                        for category in arrayOfCategories {
                            
                            if let category = category as? [String:Any] {
                                let newMainCategory = Category(context: backgroundContext)
                                newMainCategory.desc = category["desc"] as? String
                                newMainCategory.iconName = category["iconName"] as? String
                                newMainCategory.colorCode = category["colorCode"] as? String
                                newMainCategory.type = Int16(CategoryType.expense.rawValue)
                                
//                                if let subCategories = category["childs"] as? [Any] {
//                                    for subCategory in subCategories {
//                                        if let subCategory = subCategory as? [String:String] {
//                                            let newSubCategory = Category(context: backgroundContext)
//                                            newSubCategory.desc = subCategory["desc"]
//                                            newSubCategory.iconName = subCategory["iconName"]
//                                            newSubCategory.colorCode = subCategory["colorCode"]
//                                            newSubCategory.type = newMainCategory.type
//                                            newSubCategory.parent = newMainCategory
//                                        }
//                                    }
//                                }
                            }
                        }
                        
                        try backgroundContext.save()
                        
                        setupManager.isExpenseCategoriesPreloaded = true
                    }
                    print("Successfully preloaded expense category")
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func preloadSimulationData() {
        let setupManager = SetupManager.shared
        let financeManager = FinanceManager.shared
        
        if !setupManager.isSimulationPreloaded {
            guard let defaultWallet = financeManager.defaultWallet() else {return}
            
            // simulate expense
            if let expenseCategoryList = financeManager.categoryList(type: .expense) {
                for category in expenseCategoryList {
                    financeManager.insertTransaction(date: Date(), amount: Double(exactly: Int.random(in: 1000 ..< 10000))!, type: .expense, category: category, desc: "Preloaded expense 1", sourceWallet: defaultWallet)
                    financeManager.insertTransaction(date: Date(), amount: Double(exactly: Int.random(in: 1000 ..< 10000))!, type: .expense, category: category, desc: "Preloaded expense 2", sourceWallet: defaultWallet)
                    financeManager.insertTransaction(date: Date().previousStartOfMonth(), amount: Double(exactly: Int.random(in: 1000 ..< 10000))!, type: .expense, category: category, desc: "Preloaded expense 1", sourceWallet: defaultWallet)
                    financeManager.insertTransaction(date: Date().previousStartOfMonth(), amount: Double(exactly: Int.random(in: 1000 ..< 10000))!, type: .expense, category: category, desc: "Preloaded expense 2", sourceWallet: defaultWallet)
                }
            }
            
            if let incomeCategoryList = financeManager.categoryList(type: .income) {
                for category in incomeCategoryList {
                    financeManager.insertTransaction(date: Date(), amount: Double(exactly: Int.random(in: 5000 ..< 20000))!, type: .income, category: category, desc: "Preloaded income", sourceWallet: nil, benefWallet: defaultWallet)
                }
            }
            
            setupManager.isSimulationPreloaded = true;
            print("Successfully preloaded transaction simulation")
        }
    }

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "PersonalFinance")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

