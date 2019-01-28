//
//  AddRecordViewController.swift
//  PersonalFinance
//
//  Created by Gun Eight  on 20/01/19.
//  Copyright © 2019 Daniel Gunawan. All rights reserved.
//

import UIKit

class AddRecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   

    
   
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var addRecordButton: UIButton!
    
    @IBOutlet weak var categoryTableDropDown: UITableView!
    @IBOutlet weak var categoryLabel: UIButton!
    var category : String =  " "
    var categoryDummy : [String] = ["food", "transport","Parking","movies","sport"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        UICustom()
        GetDate()
        categoryLabel.setTitle("\(category)", for: .normal)
        self.categoryTableDropDown.delegate = self
        self.categoryTableDropDown.dataSource = self
        
//        categoryTableDropDown.isHidden = true
    }
   
    @IBAction func categoryButton(_ sender: Any) {
    }
    func UICustom () {
//     recordLabel.layer.cornerRadius = 10
        viewContainer.layer.cornerRadius = 10
        addRecordButton.layer.cornerRadius = 10
        dateTextField.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        viewContainer.clipsToBounds = true
        viewContainer.layer.cornerRadius = 10
        categoryLabel.clipsToBounds = true
        categoryLabel.layer.cornerRadius = 5
        categoryLabel.layer.borderWidth = 0.5
        categoryLabel.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }

        func GetDate()  {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.addTarget(self, action: #selector(self.DatePickerValue(sender:)), for: .valueChanged)
        self.dateTextField.inputView = datePicker
        self.view.endEditing(true)
    
    
        }
    
        @objc func DatePickerValue(sender : UIDatePicker)   {
            let formatter = DateFormatter()
            formatter.dateStyle = DateFormatter.Style.long
            formatter.timeStyle = DateFormatter.Style.none
            dateTextField.text = formatter.string(from: sender.date)
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryDummy.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell4", for: indexPath) as! CategoryTVC
        cell.categoryLabels.text = categoryDummy[indexPath.row]
            return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }
    
    
//    @IBAction func AddRecordTransaction(_ sender: Any) {
//        UIView.animate(withDuration: 0.3){
//            self.categoryTableDropDown.isHidden = false
//        }
//    }
    
}


