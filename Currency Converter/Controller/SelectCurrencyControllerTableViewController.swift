//
//  SelectCurrencyControllerTableViewController.swift
//  Currency Converter
//
//  Created by Iurii Chernovalov on 24.01.21.
//

import UIKit

enum FlagCurrencySelected {
    
    case from
    case to
    
}
class SelectCurrencyController: UITableViewController {
    
    var flagCurrency: FlagCurrencySelected = .from

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return CurrencyManager.shared.currenciesArray.count
        
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectedCurrency", for: indexPath)
        let currentCurrency: CurrencyModel = CurrencyManager.shared.currenciesArray[indexPath.row]
        cell.textLabel?.text = currentCurrency.currencyName
        return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCurrency: CurrencyModel = CurrencyManager.shared.currenciesArray[indexPath.row]
        
        if flagCurrency == .from {
            
                CurrencyManager.shared.fromCurrency = selectedCurrency

        } else {
            
            CurrencyManager.shared.toCurrency = selectedCurrency
            
        }
        
        dismiss(animated: true, completion: nil)
        
    }
}
