//
//  CategoryTableViewCell.swift
//  PersonalFinance
//
//  Created by Daniel Gunawan on 21/01/19.
//  Copyright © 2019 Daniel Gunawan. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryIconImageView: UIImageView!
    @IBOutlet weak var categoryDescLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
