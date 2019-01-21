//
//  CategoryTableViewCell.swift
//  PersonalFinance
//
//  Created by Gun Eight  on 14/01/19.
//  Copyright © 2019 Daniel Gunawan. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
