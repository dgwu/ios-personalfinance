//
//  ReportTableViewCell.swift
//  PersonalFinance
//
//  Created by Denis Wibisono on 09/01/19.
//  Copyright © 2019 Daniel Gunawan. All rights reserved.
//

import UIKit

class ReportTableViewCell: UITableViewCell {
    
    @IBOutlet weak var expenseCategory: UILabel!
    @IBOutlet weak var expenseCategoryValue: UILabel!
    @IBOutlet weak var categorySymbolImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
