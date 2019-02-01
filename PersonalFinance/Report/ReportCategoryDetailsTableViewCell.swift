//
//  ReportCategoryDetailsTableViewCell.swift
//  PersonalFinance
//
//  Created by Denis Wibisono on 14/01/19.
//  Copyright © 2019 Daniel Gunawan. All rights reserved.
//

import UIKit

class ReportCategoryDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var expenseDescLabel: UILabel!
    @IBOutlet weak var expenseDescValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
