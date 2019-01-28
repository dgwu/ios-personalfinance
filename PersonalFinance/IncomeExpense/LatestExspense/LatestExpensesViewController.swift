//
//  LatestExpensesViewController.swift
//  PersonalFinance
//
//  Created by Gun Eight  on 21/01/19.
//  Copyright © 2019 Daniel Gunawan. All rights reserved.
//

import UIKit

class LatestExpensesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! LatestExpensesTableViewCell
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


}
