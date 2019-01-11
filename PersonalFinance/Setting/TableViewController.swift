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
    
    let defaults = UserDefaults.resetStandardUserDefaults()
    
    
    
    //defaults.setObject("Coding Explorer", forKey: "userNameKey")
    
    @IBOutlet weak var notifState: UISwitch!
    
    @IBAction func actNotifState(_ sender: Any)
    {
        if (notifState.isOn == true)
        {
        print("aktif")
           // defaults.
        }else
        {
            print("gak aktif")
        }
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("selected row is \(indexPath.section)")
        print("selected row is \(indexPath.row)")
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let myCell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as? UITableViewCell
//
//        print(myCell)
//
//            if(indexPath.row == 0)
//            {
//                myCell?.isHidden = true
//            }
//            else
//            {
//                myCell?.isHidden = false
//            }
//        return myCell!
//    }
    
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
