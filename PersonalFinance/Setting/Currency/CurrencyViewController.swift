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

    let currency = [
        "IDR - Indonesia",
        "USD - US Dollar",
        "SGD - Singapore Dollar",
        "MYR - Malaysian Ringgit",
        "CNY - Chinese Yuan Renminbi"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return currency.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = currency[indexPath.row]
        return cell
    }
    
    
    
    
    
    
}
