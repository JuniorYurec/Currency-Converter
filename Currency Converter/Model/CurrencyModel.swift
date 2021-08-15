//
//  CurrencyModel.swift
//  Currency Converter
//
//  Created by Iurii Chernovalov on 17.01.21.
//

import UIKit

struct CurrencyModel {

    var currencyCode: String?
    var currencyRate: Double?
    var currencyRateStr: String?
    var currencyName: String?
    var currencyImage: UIImage? {
        
        if let currencyCode = currencyCode {
            
            return UIImage(named: currencyCode + ".png")
            
        }
        return nil
    }
}
