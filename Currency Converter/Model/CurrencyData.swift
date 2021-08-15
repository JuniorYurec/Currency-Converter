//
//  CurrencyData.swift
//  Currency Converter
//
//  Created by Iurii Chernovalov on 17.01.21.
//

import Foundation

class CurrencyData: Decodable {
    
    let base: String
    let rates: [String: Double]
}
