//
//  TableViewCell.swift
//  PersonalFinance
//
//  Created by Gun Eight  on 08/01/19.
//  Copyright © 2019 Daniel Gunawan. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var expansesNameLabel: UILabel!
    @IBOutlet weak var amountExpensesLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
