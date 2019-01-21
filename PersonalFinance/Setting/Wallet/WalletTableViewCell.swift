//
//  WalletTableViewCell.swift
//  PersonalFinance
//
//  Created by Daniel Gunawan on 21/01/19.
//  Copyright © 2019 Daniel Gunawan. All rights reserved.
//

import UIKit

class WalletTableViewCell: UITableViewCell {

    @IBOutlet weak var walletIconImageView: UIImageView!
    @IBOutlet weak var walletDescLabel: UILabel!
    @IBOutlet weak var walletAmountLabel: UILabel!
    var wallet: Wallet? {
        didSet {
            self.viewSetup()
        }
    }
    
    func viewSetup() {
        if let wallet = self.wallet {
            self.walletIconImageView.image = UIImage(named: wallet.iconName!)
            self.walletDescLabel.text = wallet.desc
            self.walletAmountLabel.text = "\(wallet.initialAmount)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
