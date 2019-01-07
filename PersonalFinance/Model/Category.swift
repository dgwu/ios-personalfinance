//
//  Category.swift
//  PersonalFinance
//
//  Created by Daniel Gunawan on 07/01/19.
//  Copyright © 2019 Daniel Gunawan. All rights reserved.
//

import Foundation

struct Category {
    let id: Int
    var desc: String
    var iconName: String
    var colorCode: String
    var parentId: Int
    let type: CategoryType
}

enum CategoryType {
    case expense
    case income
}
