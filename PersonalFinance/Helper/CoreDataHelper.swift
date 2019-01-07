//
//  CoreDataHelper.swift
//  PersonalFinance
//
//  Created by Daniel Gunawan on 07/01/19.
//  Copyright © 2019 Daniel Gunawan. All rights reserved.
//

import CoreData
import UIKit

class CoreDataHelper{
    
    func objectContext() -> NSManagedObjectContext{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            //This should never happen
            return NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        }
        
        return appDelegate.persistentContainer.viewContext
    }
    
}
