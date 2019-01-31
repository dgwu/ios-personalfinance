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
        self.contentView.addSubview(imageView!)
        self.imageView!.addSubview(categoryImage)
        self.contentView.addSubview(trasactionNameLabel)
        self.contentView.addSubview(transactionAmountLabel)
        
        //contraint name of transaction
       
        NSLayoutConstraint.activate([
            imageView!.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView!.widthAnchor.constraint(equalToConstant: (contentView.frame.size.width / 8) - 15),
            imageView!.heightAnchor.constraint(equalToConstant: (contentView.frame.size.width / 8) - 15)
            ])
      
      
        
        NSLayoutConstraint.activate([
            categoryImage.topAnchor.constraint(equalTo: imageView!.topAnchor, constant : 5),
            categoryImage.bottomAnchor.constraint(equalTo: imageView!.bottomAnchor ),
            categoryImage.leadingAnchor.constraint(equalTo: imageView!.trailingAnchor, constant : 10),
            categoryImage.widthAnchor.constraint(equalToConstant: (imageView?.frame.width)! - 5),
            categoryImage.heightAnchor.constraint(equalToConstant: (imageView?.frame.height)! - 5)
            ])
        
        NSLayoutConstraint.activate([
            trasactionNameLabel.leadingAnchor.constraint(equalTo: categoryImage.trailingAnchor, constant : 20),
            trasactionNameLabel.widthAnchor.constraint(equalToConstant: (contentView.frame.width / 2) - 10),
            trasactionNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
            ])
        
        NSLayoutConstraint.activate([
            transactionAmountLabel.leadingAnchor.constraint(equalTo: trasactionNameLabel.trailingAnchor, constant : 30),
            transactionAmountLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            transactionAmountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
            ])
  
      
//        categoryImage.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        print("view image : \(imageView!.frame.width)")
         print("view image : \(imageView!.frame.height)")
        print("image width : \(categoryImage.frame)")
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
//        label.backgroundColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        return label
    }()
    
    let transactionAmountLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura", size: 15)
        label.textColor = #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.text = "Rp 80.000.000"
        return label
    }()
    
    let categoryImage : UIImageView = {
        
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 5
        image.layer.borderWidth = 1
        image.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        image.image = UIImage(named: "sports-car")
        return image
    }()
    
    let viewImage : UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 1
        view.layer.backgroundColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        
        return view
    }()
    
    
    
}
