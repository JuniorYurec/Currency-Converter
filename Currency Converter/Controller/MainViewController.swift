//
//  ViewController.swift
//  Currency Converter
//
//  Created by Iurii Chernovalov on 17.01.21.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate{
    @IBOutlet weak var currencyTableView: UITableView!
    @IBOutlet weak var fromCurrency: UIButton!
    @IBOutlet weak var toCurrency: UIButton!
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var textFromCurrency: UITextField!
    @IBOutlet weak var fromCurrencyImageVIew: UIImageView!
    @IBOutlet weak var toCurrencyImageView: UIImageView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //        register a custom cell2
        currencyTableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        CurrencyManager.shared.setDefaultFromToCurrencies()
        CurrencyManager.shared.getExchangeRates(for: "latest", base: "EUR") {
            self.currencyTableView.reloadData()
        }
        currencyTableView.delegate = self
        currencyTableView.dataSource = self
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        refreshButtons()
        textFromEditiongChanged(self)
        currencyTableView.reloadData()
        
    }
    
    @IBAction func textFromEditiongChanged(_ sender: Any) {
        
        let textFromDouble = Double(textFromCurrency.text!)
        if textFromDouble != nil {
            
            resultLabel.text = CurrencyManager.shared.convert(amount: textFromDouble!)
            
        }
    }
    
    
    @IBAction func pushFromButton(_ sender: Any) {
//        show a list of currencies to choose one of them for the fromCurrency
        let nc = storyboard?.instantiateViewController(identifier: K.selectedNavigationCtroller) as! UINavigationController
        (nc.viewControllers[0] as! SelectCurrencyController).flagCurrency = .from
        nc.modalPresentationStyle = .fullScreen
        present(nc, animated: true, completion: nil)
        
    }
    
    @IBAction func pushToButton(_ sender: Any) {
//        show a list of currencies to choose one of them for the toCurrency
        let nc = storyboard?.instantiateViewController(identifier: K.selectedNavigationCtroller) as! UINavigationController
        (nc.viewControllers[0] as! SelectCurrencyController).flagCurrency = .to
        nc.modalPresentationStyle = .fullScreen
        present(nc, animated: true, completion: nil)
        
    }
    
    func refreshButtons(){
//        set default values for the fromCurrency, toCurrency, resultLabel, textFromCurrency
        fromCurrency.setTitle("\(CurrencyManager.shared.fromCurrency?.currencyCode ?? ".")  ⌄", for: UIControl.State.normal)
        toCurrency.setTitle("\(CurrencyManager.shared.toCurrency?.currencyCode ?? ".")  ⌄", for: UIControl.State.normal)
        fromCurrencyImageVIew.image = CurrencyManager.shared.fromCurrency?.currencyImage
        toCurrencyImageView.image = CurrencyManager.shared.toCurrency?.currencyImage
        resultLabel.text = ""
        textFromCurrency.text = ""
        
    }
}

//   MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return CurrencyManager.shared.currenciesArray.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // make our Cell a type of ExchangeRateCell
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! CurrencyCell
        let currentCurrency = CurrencyManager.shared.currenciesArray[indexPath.row]
        //save in our cell a new custom Cell
        cell.currencyNameLabel.text = currentCurrency.currencyName
        cell.currencyRateLabel.text = currentCurrency.currencyRateStr
        cell.currencyImageView.image = currentCurrency.currencyImage
        return cell
        
    }
}

//   MARK: - UITouchEndEditing
extension MainViewController {
    
    // Ends editing view when touches to view
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
        
    }
}
