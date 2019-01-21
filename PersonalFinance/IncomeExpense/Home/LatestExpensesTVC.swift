//
//  LatestExpensesTVC.swift
//  PersonalFinance
//
//  Created by Gun Eight  on 19/01/19.
//  Copyright © 2019 Daniel Gunawan. All rights reserved.
//

import UIKit

class LatestExpensesTVC: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(categoryImage)
        self.contentView.addSubview(trasactionNameLabel)
        self.contentView.addSubview(transactionAmountLabel)
      
        
        //contraint name of transaction
        NSLayoutConstraint.activate([
            trasactionNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant : 20),
            trasactionNameLabel.widthAnchor.constraint(equalToConstant: (contentView.frame.width / 2) - (contentView.frame.width / 8) - 10 ),
            trasactionNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
            ])
        
        NSLayoutConstraint.activate([
            transactionAmountLabel.leadingAnchor.constraint(equalTo: trasactionNameLabel.trailingAnchor),
            transactionAmountLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            transactionAmountLabel.widthAnchor.constraint(equalToConstant: (contentView.frame.width / 2) - (contentView.frame.width / 8) - 10 ),
            ])
       
        NSLayoutConstraint.activate([
            categoryImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant : -10),
        categoryImage.topAnchor.constraint(equalTo: contentView.topAnchor),
//        categoryImage.leftAnchor.constraint(equalTo: transactionAmountLabel.trailingAnchor, constant : 5),
        categoryImage.widthAnchor.constraint(equalToConstant: (contentView.frame.width / 8) - 15),
        categoryImage.heightAnchor.constraint(equalToConstant: (contentView.frame.width / 8) - 15)
        ])
        
      
//        categoryImage.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        print("image width : \(categoryImage.frame.width)")
         print("image height : \(categoryImage.frame.height)")
        print("amount label : \((contentView.frame.width / 2) - (contentView.frame.width / 8) - 10)")
       print("amount label === \(contentView.frame.width)" )
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    let trasactionNameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura", size: 15)
        label.textColor = #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = "MC Donald's"
        return label
    }()
    
    let transactionAmountLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura", size: 15)
        label.textColor = #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = "Rp 80.000.000"
        return label
    }()
    
    let categoryImage : UIImageView = {
        
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 5
        image.layer.borderWidth = 1
        image.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        image.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        image.image = UIImage(named: "sports-car")
        return image
    }()
    
    
    
}
