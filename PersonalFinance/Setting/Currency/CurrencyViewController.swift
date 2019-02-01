//
//  CurrencyViewController.swift
//  PersonalFinance
//
//  Created by okky pribadi on 21/01/19.
//  Copyright © 2019 Daniel Gunawan. All rights reserved.
//

import UIKit

class CurrencyViewController: UITableViewController
{
let setupManager = SetupManager.shared
    
    let currency = [
        "IDR - Indonesia",
        "USD - US Dollar",
        "SGD - Singapore Dollar",
        "MYR - Malaysian Ringgit",
        "CNY - Chinese Yuan Renminbi",
        "JPY - Japanese Yen",
        "EUR - Euro",
        "AUD - Australian Dollar"]
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    
    func find(value searchValue: String, in array: [String]) -> Int?
    {
        for (index, value) in array.enumerated()
        {
            if value == searchValue {
                return index
            }
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return currency.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = currency[indexPath.row]
        let index = find(value: "\(setupManager.userDefaultCurrency)", in: currency)

        if (index! == indexPath.row)
        {
            cell.accessoryType = .checkmark
        }

        //ini buat ilangin separatornya
        //self.tableView.separatorStyle =  .none
        //self.tableView.tableFooterView = UIView(frame: CGRect(x: 50, y: 0, width: tableView.frame.size.width, height: 1))
       
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
//        let index3 = currency[indexPath.row].index(currency[indexPath.row].startIndex, offsetBy: 3)
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
       // setupManager.userDefaultCurrency = "\(currency[indexPath.row].prefix(upTo: index3))"
        setupManager.userDefaultCurrency = "\(currency[indexPath.row])"
       // tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
    {
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
    }
    
}
