//
//  WalletDetailViewController.swift
//  PersonalFinance
//
//  Created by Daniel Gunawan on 21/01/19.
//  Copyright © 2019 Daniel Gunawan. All rights reserved.
//

import UIKit

protocol WalletDetailViewControllerDelegate {
    func walletUpdate()
}

class WalletDetailViewController: UIViewController {
    // form controller
    var nameTextField: UITextField!
    var initialAmountTextField: UITextField!
    var openDateButton: UIButton!
    var openDatePicker: UIDatePicker!
    
    var delegate: WalletDetailViewControllerDelegate?
    let financeManager = FinanceManager.shared
    var wallet: Wallet?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        if let wallet = self.wallet {
            self.navigationItem.title = wallet.desc
        } else {
            self.navigationItem.title = "New Wallet"
        }
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeThis))
        self.navigationItem.leftBarButtonItem = closeButton
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        self.navigationItem.rightBarButtonItem = saveButton
        
        self.view.backgroundColor = UIColor.white
        
        let nameLabel = UILabel()
        nameLabel.text = "Name"
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            nameLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        nameTextField = UITextField()
        nameTextField.placeholder = "Name"
        nameTextField.text = wallet?.desc
        nameTextField.textAlignment = .right
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(nameTextField)
        NSLayoutConstraint.activate([
            nameTextField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 10),
            nameTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            nameTextField.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor)
        ])
        
        let nameSeparator = UIView()
        nameSeparator.translatesAutoresizingMaskIntoConstraints = false
        nameSeparator.backgroundColor = UIColor.lightGray
        nameSeparator.alpha = 0.5
        self.view.addSubview(nameSeparator)
        NSLayoutConstraint.activate([
            nameSeparator.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            nameSeparator.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            nameSeparator.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 5),
            nameSeparator.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        let initialAmountLabel = UILabel()
        initialAmountLabel.text = "Initial Amount"
        initialAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(initialAmountLabel)
        NSLayoutConstraint.activate([
            initialAmountLabel.topAnchor.constraint(equalTo: nameSeparator.bottomAnchor, constant: 10),
            initialAmountLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            initialAmountLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        initialAmountTextField = UITextField()
        initialAmountTextField.placeholder = "0.0"
        initialAmountTextField.text = "\(wallet?.initialAmount ?? 0)"
        initialAmountTextField.textAlignment = .right
        initialAmountTextField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(initialAmountTextField)
        NSLayoutConstraint.activate([
            initialAmountTextField.leadingAnchor.constraint(equalTo: initialAmountLabel.trailingAnchor, constant: 10),
            initialAmountTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            initialAmountTextField.centerYAnchor.constraint(equalTo: initialAmountLabel.centerYAnchor)
        ])
        
        let initialAmountSeparator = UIView()
        initialAmountSeparator.translatesAutoresizingMaskIntoConstraints = false
        initialAmountSeparator.backgroundColor = UIColor.lightGray
        initialAmountSeparator.alpha = 0.5
        self.view.addSubview(initialAmountSeparator)
        NSLayoutConstraint.activate([
            initialAmountSeparator.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            initialAmountSeparator.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            initialAmountSeparator.topAnchor.constraint(equalTo: initialAmountTextField.bottomAnchor, constant: 5),
            initialAmountSeparator.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        let openDateLabel = UILabel()
        openDateLabel.text = "Open Date"
        openDateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(openDateLabel)
        NSLayoutConstraint.activate([
            openDateLabel.topAnchor.constraint(equalTo: initialAmountSeparator.bottomAnchor, constant: 10),
            openDateLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            openDateLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        openDateButton = UIButton(type: .custom)
        openDateButton.translatesAutoresizingMaskIntoConstraints = false
        openDateButton.setTitleColor(UIColor.lightGray, for: .normal)
        openDateButton.setTitleColor(UIColor.red, for: .focused)
        openDateButton.setTitle("Today", for: .normal)
        openDateButton.addTarget(self, action: #selector(toggleDatePicker), for: .touchUpInside)
        self.view.addSubview(openDateButton)
        NSLayoutConstraint.activate([
            openDateButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            openDateButton.centerYAnchor.constraint(equalTo: openDateLabel.centerYAnchor)
        ])
        
        let openDateSeparator = UIView()
        openDateSeparator.translatesAutoresizingMaskIntoConstraints = false
        openDateSeparator.backgroundColor = UIColor.lightGray
        openDateSeparator.alpha = 0.5
        self.view.addSubview(openDateSeparator)
        NSLayoutConstraint.activate([
            openDateSeparator.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            openDateSeparator.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            openDateSeparator.topAnchor.constraint(equalTo: openDateButton.bottomAnchor, constant: 5),
            openDateSeparator.heightAnchor.constraint(equalToConstant: 1)
            ])
        
        openDatePicker = UIDatePicker()
        openDatePicker.translatesAutoresizingMaskIntoConstraints = false
        openDatePicker.datePickerMode = .date
        openDatePicker.addTarget(self, action: #selector(openDateDidChange), for: .valueChanged)
        if let existDate = wallet?.createdDate {
            openDatePicker.setDate(existDate, animated: false)
            openDateDidChange(sender: openDatePicker)
        }
        openDatePicker.isHidden = true
        self.view.addSubview(openDatePicker)
        NSLayoutConstraint.activate([
            openDatePicker.topAnchor.constraint(equalTo: openDateSeparator.bottomAnchor),
            openDatePicker.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            openDatePicker.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15)
        ])
    }
    
    @objc func toggleDatePicker() {
        UIView.animate(withDuration: 0.2, animations: {
            if (self.openDatePicker.isHidden) {
                self.openDatePicker.alpha = 1
            } else {
                self.openDatePicker.alpha = 0
            }
        }) { (_) in
            self.openDatePicker.isHidden.toggle()
        }
    }
    
    @objc func openDateDidChange(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        dateFormatter.timeZone = Calendar.current.timeZone
        
        openDateButton.setTitle(dateFormatter.string(from: sender.date), for: .normal)
    }
    
    @objc func save() {
        guard let walletName = nameTextField.text else {return}
        
        if (walletName.count < 1) {
            UIView.animate(withDuration: 0.2, animations: {
                self.nameTextField.transform = CGAffineTransform.init(translationX: -15, y: 0)
            }) { (_) in
                self.nameTextField.transform = CGAffineTransform.identity
            }
            return
        }
        
        
        if let wallet = self.wallet {
            print("update wallet")
            wallet.setValuesForKeys([
                "desc" : walletName,
                "initialAmount" : ((self.initialAmountTextField.text ?? "0") as NSString).doubleValue,
                "iconName" : "category",
                "colorCode" : "fff000",
                "createdDate" : self.openDatePicker.date
                ])
            
            do {
                try financeManager.objectContext.save()
            } catch {
                print("Failed to save core data. \(error.localizedDescription)")
            }
        } else {
            print("insert wallet")
            financeManager.insertWallet(desc: walletName, openDate: self.openDatePicker.date, initialAmount: ((self.initialAmountTextField.text ?? "0") as NSString).doubleValue, iconName: "category", colorCode: "fff000")
        }
        
        delegate?.walletUpdate()
        closeThis()
    }
    
    @objc func closeThis() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

}
