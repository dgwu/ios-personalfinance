//
//  MainSetting.swift
//  PersonalFinance
//
//  Created by okky pribadi on 08/01/19.
//  Copyright © 2019 Daniel Gunawan. All rights reserved.
//

import Foundation
import UIKit


class TableViewController: UITableViewController
{
    let setupManager = SetupManager.shared
    
    @IBOutlet weak var lblSalary: UILabel!
    @IBOutlet weak var lblSaving: UILabel!
    @IBOutlet weak var lblCurrency: UILabel!
    
    // for notification
    @IBOutlet weak var notifState: UISwitch!
    @IBAction func actNotifState(_ sender: Any)
    {
        if (notifState.isOn == true)
        {
            setupManager.isUserAllowNotification = true
        }else
        {
            setupManager.isUserAllowNotification = false
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAccount", let destination = segue.destination as? AccountViewController, let _ = tableView.indexPathForSelectedRow?.row
        {
            print("segue jalan")
            destination.bangke = "bangke jason!!!!"
        }else if segue.identifier == "showSal", let destination = segue.destination as? SalaryViewController, let indexTable = tableView.indexPathForSelectedRow?.row
        {
        }
    }
    
    
    //for Decimal
    @IBOutlet weak var decimalState: UISwitch!
    @IBAction func actDecimal(_ sender: Any)
    {
        if (decimalState.isOn == true)
        {
            setupManager.isUserUsingDecimal = true
        }else
        {
            setupManager.isUserUsingDecimal = false
        }
    }
    
    //defaults.setObject("Coding Explorer", forKey: "userNameKey")
 
    
    func initialLoad()
    {
        lblSalary.text = "\(NumberFormatter.localizedString(from: NSNumber(value: setupManager.userMonthlySalary), number: .decimal))"
        lblSaving.text = "\(NumberFormatter.localizedString(from: NSNumber(value: setupManager.userMonthlySaving), number: .decimal))"
        lblCurrency.text = setupManager.userDefaultCurrency
        
        
        notifState.isOn = setupManager.isUserAllowNotification
        decimalState.isOn = setupManager.isUserUsingDecimal
        
        
    }
    
    override func viewDidLoad()
    {
        initialLoad()
        
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("selected row is \(indexPath.section)")
        print("selected row is \(indexPath.row)")
    }
    
    
}


//
//func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//
//    var myCell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("cellID",forIndexPath: indexPath) as? UITableViewCell
//
//    if(indexPath.row == 1){
//        myCell?.hidden = true
//    }else{
//        myCell?.hidden = false
//    }
//
//    return myCell
//}
