//
//  ReportCategoryDetailsViewController.swift
//  PersonalFinance
//
//  Created by Denis Wibisono on 10/01/19.
//  Copyright © 2019 Daniel Gunawan. All rights reserved.
//

import UIKit

class ReportCategoryDetailsViewController: UIViewController {
    @IBOutlet weak var categoryNameLabel: UILabel!
    var selectedCategory : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryNameLabel.text = selectedCategory
        self.title = selectedCategory
    }
}
