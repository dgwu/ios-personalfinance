//
//  Transaction.swift
//  PersonalFinance
//
//  Created by Daniel Gunawan on 07/01/19.
//  Copyright © 2019 Daniel Gunawan. All rights reserved.
//

import Foundation

struct Transaction {
    let id: Int
    var desc: String
    var category: Category
    var sourceWallet: Wallet
    var beneficiaryWallet: Wallet?
    var transactionType: TransactionType
    var amount: Double
    var isSynced: Bool
    var transactionDate: Date
    var createdDate: Date
}


enum TransactionType {
    case expense
    case income
    case transfer
}
