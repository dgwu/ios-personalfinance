//
//  AddRecordViewController.swift
//  PersonalFinance
//
//  Created by Gun Eight  on 20/01/19.
//  Copyright © 2019 Daniel Gunawan. All rights reserved.
//

import UIKit

class AddRecordViewController: UIViewController {

    
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var addRecordButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        UICustom()
    }
   
    func UICustom () {
//     recordLabel.clipsToBounds = true
//    viewContainer.clipsToBounds = true
//        addRecordButton.clipsToBounds = true
     recordLabel.layer.cornerRadius = 10
     viewContainer.layer.cornerRadius = 10
     addRecordButton.layer.cornerRadius = 10
    }



}
