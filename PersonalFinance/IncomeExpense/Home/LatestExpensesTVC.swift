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
        self.contentView.addSubview(viewImage)
        self.viewImage.addSubview(categoryImage)
        self.contentView.addSubview(trasactionNameLabel)
        self.contentView.addSubview(transactionAmountLabel)
        
        //contraint name of transaction
       
        NSLayoutConstraint.activate([
            viewImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            viewImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant : 10),
            viewImage.widthAnchor.constraint(equalToConstant:(contentView.frame.size.width / 8 ) - 15 ),
            viewImage.heightAnchor.constraint(equalToConstant:(contentView.frame.size.width / 8 ) - 15 )
            ])
        
        NSLayoutConstraint.activate([
            categoryImage.centerXAnchor.constraint(equalTo: viewImage.centerXAnchor),
            categoryImage.centerYAnchor.constraint(equalTo: viewImage.centerYAnchor),
            categoryImage.widthAnchor.constraint(equalToConstant:(contentView.frame.size.width / 8 ) - 25),
            categoryImage.heightAnchor.constraint(equalToConstant:(contentView.frame.size.width / 8 ) - 25)
            ])
        
        categoryImage.layoutIfNeeded()
        print("ini framenya = \(categoryImage.frame)")
        
        NSLayoutConstraint.activate([
            trasactionNameLabel.leadingAnchor.constraint(equalTo: viewImage.trailingAnchor, constant : 10),
//            trasactionNameLabel.widthAnchor.constraint(equalToConstant: (contentView.frame.width / 2) - 30),
            trasactionNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant : 5)
            ])
        trasactionNameLabel.layoutIfNeeded()

        NSLayoutConstraint.activate([
            transactionAmountLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant : 5),
            trasactionNameLabel.widthAnchor.constraint(equalToConstant: (contentView.frame.width / 2) - 30),
            transactionAmountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
//            transactionAmountLabel.widthAnchor.constraint(equalToConstant: (contentView.frame.width / 2) - (contentView.frame.width / 8) - 10),
            transactionAmountLabel.leadingAnchor.constraint(equalTo: trasactionNameLabel.trailingAnchor)
            ])

//        categoryImage.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            print("ini \((contentView.frame.size.width / 8) - 15)")
            print("view image : \(viewImage.frame.size.width)")
            print("view image : \(viewImage.frame.size.height)")
            print("image width : \(categoryImage.frame)")
            print("image height : \(categoryImage.frame.height)")
            print("amount label : \((contentView.frame.width / 2) - (contentView.frame.width / 8) - 10)")
            print("amount label === \(contentView.frame.width)" )
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    let viewImage : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
//        view.layer.cornerRadius = 5
//        view.layer.borderWidth = 0.5
//        view.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return view
    }()
    
    let trasactionNameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SF Pro Text", size: 14)
        label.textColor = #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = "MC Donald's"
        
        return label
    }()
    
    let transactionAmountLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SF Pro Text", size: 14)
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
        image.image = UIImage(named: "sports-car")
        return image
    }()
    
    
    
    
    
}
