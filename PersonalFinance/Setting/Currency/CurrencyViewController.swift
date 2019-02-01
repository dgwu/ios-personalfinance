//
//  CurrencyViewController.swift
//  PersonalFinance
//
//  Created by okky pribadi on 21/01/19.
//  Copyright © 2019 Daniel Gunawan. All rights reserved.
//

import UIKit

protocol CurrencyViewControllerDelegate {
    func updateCurrency()
}

class CurrencyViewController: UITableViewController
{

    let setupManager = SetupManager.shared
    var selectedIndexPath: IndexPath?
    var delegate: CurrencyViewControllerDelegate?
    
    let currencyList: [(String, String)] = [
        ("$", "US dollars"),
        ("$", "Canadian dollars"),
        ("€", "Euros"),
        ("د.إ.‏", "UAE dirhams"),
        ("؋", "Afghan Afghanis"),
        ("Lek", "Albanian lekë"),
        ("դր.", "Armenian drams"),
        ("$", "Argentine pesos"),
        ("$", "Australian dollars"),
        ("ман.", "Azerbaijani manats"),
        ("KM", "Bosnia-Herzegovina convertible marks"),
        ("৳", "Bangladeshi takas"),
        ("лв.", "Bulgarian leva"),
        ("د.ب.‏", "Bahraini dinars"),
        ("FBu", "Burundian francs"),
        ("$", "Brunei dollars"),
        ("Bs", "Bolivian bolivianos"),
        ("R$", "Brazilian reals"),
        ("P", "Botswanan pulas"),
        ("BYR", "Belarusian rubles"),
        ("$", "Belize dollars"),
        ("FrCD", "Congolese francs"),
        ("CHF", "Swiss francs"),
        ("$", "Chilean pesos"),
        ("CN¥", "Chinese yuan"),
        ("$", "Colombian pesos"),
        ("₡", "Costa Rican colóns"),
        ("CV$", "Cape Verdean escudos"),
        ("Kč", "Czech Republic korunas"),
        ("Fdj", "Djiboutian francs"),
        ("kr", "Danish kroner"),
        ("RD$", "Dominican pesos"),
        ("د.ج.‏", "Algerian dinars"),
        ("kr", "Estonian kroons"),
        ("ج.م.‏", "Egyptian pounds"),
        ("Nfk", "Eritrean nakfas"),
        ("Br", "Ethiopian birrs"),
        ("£", "British pounds sterling"),
        ("GEL", "Georgian laris"),
        ("GH₵", "Ghanaian cedis"),
        ("FG", "Guinean francs"),
        ("Q", "Guatemalan quetzals"),
        ("$", "Hong Kong dollars"),
        ("L", "Honduran lempiras"),
        ("kn", "Croatian kunas"),
        ("Ft", "Hungarian forints"),
        ("Rp", "Indonesian rupiahs"),
        ("₪", "Israeli new sheqels"),
        ("টকা", "Indian rupees"),
        ("د.ع.‏", "Iraqi dinars"),
        ("﷼", "Iranian rials"),
        ("kr", "Icelandic krónur"),
        ("$", "Jamaican dollars"),
        ("د.أ.‏", "Jordanian dinars"),
        ("￥", "Japanese yen"),
        ("Ksh", "Kenyan shillings"),
        ("៛", "Cambodian riels"),
        ("FC", "Comorian francs"),
        ("₩", "South Korean won"),
        ("د.ك.‏", "Kuwaiti dinars"),
        ("тңг.", "Kazakhstani tenges"),
        ("ل.ل.‏", "Lebanese pounds"),
        ("SL Re", "Sri Lankan rupees"),
        ("Lt", "Lithuanian litai"),
        ("Ls", "Latvian lati"),
        ("د.ل.‏", "Libyan dinars"),
        ("د.م.‏", "Moroccan dirhams"),
        ("MDL", "Moldovan lei"),
        ("MGA", "Malagasy Ariaries"),
        ("MKD", "Macedonian denari"),
        ("K", "Myanma kyats"),
        ("MOP$", "Macanese patacas"),
        ("MURs", "Mauritian rupees"),
        ("$", "Mexican pesos"),
        ("RM", "Malaysian ringgits"),
        ("MTn", "Mozambican meticals"),
        ("N$", "Namibian dollars"),
        ("₦", "Nigerian nairas"),
        ("C$", "Nicaraguan córdobas"),
        ("kr", "Norwegian kroner"),
        ("नेरू", "Nepalese rupees"),
        ("$", "New Zealand dollars"),
        ("ر.ع.‏", "Omani rials"),
        ("B/.", "Panamanian balboas"),
        ("S/.", "Peruvian nuevos soles"),
        ("₱", "Philippine pesos"),
        ("₨", "Pakistani rupees"),
        ("zł", "Polish zlotys"),
        ("₲", "Paraguayan guaranis"),
        ("ر.ق.‏", "Qatari rials"),
        ("RON", "Romanian lei"),
        ("дин.", "Serbian dinars"),
        ("руб.", "Russian rubles"),
        ("FR", "Rwandan francs"),
        ("ر.س.‏", "Saudi riyals"),
        ("SDG", "Sudanese pounds"),
        ("kr", "Swedish kronor"),
        ("$", "Singapore dollars"),
        ("Ssh", "Somali shillings"),
        ("ل.س.‏", "Syrian pounds"),
        ("฿", "Thai baht"),
        ("د.ت.‏", "Tunisian dinars"),
        ("T$", "Tongan paʻanga"),
        ("TL", "Turkish Lira"),
        ("$", "Trinidad and Tobago dollars"),
        ("NT$", "New Taiwan dollars"),
        ("TSh", "Tanzanian shillings"),
        ("₴", "Ukrainian hryvnias"),
        ("USh", "Ugandan shillings"),
        ("$", "Uruguayan pesos"),
        ("UZS", "Uzbekistan som"),
        ("Bs.F.", "Venezuelan bolívars"),
        ("₫", "Vietnamese dong"),
        ("FCFA", "CFA francs BEAC"),
        ("CFA", "CFA francs BCEAO"),
        ("ر.ي.‏", "Yemeni rials"),
        ("R", "South African rand"),
        ("ZK", "Zambian kwachas")
    ]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return currencyList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath)
        let currency = currencyList[indexPath.row]
        
        cell.textLabel?.text = currency.1
        cell.detailTextLabel?.text = currency.0
        if setupManager.userDefaultCurrencyName == currency.1 {
            selectedIndexPath = indexPath
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // set currency
        let selectedCurrency = currencyList[indexPath.row]
        setupManager.userDefaultCurrency = selectedCurrency.0
        setupManager.userDefaultCurrencyName = selectedCurrency.1
        
        // remove last checkmark
        if let selectedIndexPath = selectedIndexPath {
            tableView.cellForRow(at: selectedIndexPath)?.accessoryType = .none
        }
        
        // set new checkmark
        selectedIndexPath = indexPath
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        delegate?.updateCurrency()
    }
    
    
    
    
    
    
}
