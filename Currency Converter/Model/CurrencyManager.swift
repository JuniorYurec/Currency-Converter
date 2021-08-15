//
//  CurrencyManager.swift
//  Currency Converter
//
//  Created by Iurii Chernovalov on 17.01.21.
//

import Foundation

class CurrencyManager {
    
    static let shared = CurrencyManager()
    private let currencyURL = "http://api.exchangeratesapi.io/v1/"
    private let accessKey = "a566017f079583a86b95ab3ec05572c0"
    var currenciesArray: [CurrencyModel] = []
    private let currenciesNamesDictionary: [String:String] = ["EUR":"Euro","GBP":"Pound sterling","HKD":"Hong Kong dollar","IDR":"Indonesian rupiah","ILS":"Israeli new shekel","DKK":"Danish krone","INR":"Indian rupee","CHF":"Swiss franc","MXN":"Mexican peso","CZK":"Czech koruna","SGD":"Singapore dollar","THB":"Thai baht","HRK":"Croatian kuna","MYR":"Malaysian ringgit","NOK":"Norwegian krone","CNY":"Chinese yuan","BGN":"Bulgarian lev","PHP":"Philippine peso","SEK":"Swedish krona","PLN":"Polish złoty","ZAR":"South African rand","CAD":"Canadian dollar","ISK":"Icelandic króna","BRL":"Brazilian real","RON":"Romanian leu","NZD":"New Zealand dollar","TRY":"Turkish lira","JPY":"Japanese yen","RUB":"Russian ruble","KRW":"South Korean won","USD":"United States dollar","HUF":"Hungarian forint","AUD":"Australian dollar"]
    var fromCurrency: CurrencyModel?
    var toCurrency: CurrencyModel?
    
    func convert(amount: Double) -> String {
        var convertedCurrency: Double?
        if fromCurrency?.currencyName == "Euro" {
            convertedCurrency = (toCurrency?.currencyRate!)!*amount
            return String(format: "%.2f", convertedCurrency!)
        } else {
            convertedCurrency = ((toCurrency?.currencyRate)!/(fromCurrency?.currencyRate)!)*amount
            return String(format: "%.2f", convertedCurrency!)
        }

        
    }
    func setDefaultFromToCurrencies(){
        
        fromCurrency = CurrencyModel(currencyCode: "EUR", currencyRate: 1, currencyRateStr: "1", currencyName: "Euro")
        toCurrency = CurrencyModel(currencyCode: "EUR", currencyRate: 1, currencyRateStr: "1", currencyName: "Euro")
        
    }
    
    func getExchangeRates(for date: String, base: String, copleted: @escaping ()->()) {
        let currenciesString = buildCurrenciesString(dictionary: currenciesNamesDictionary)
        
        let urlString = "\(currencyURL)\(date)?access_key=\(accessKey)&base=\(base)&symbols=\(currenciesString)"

        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if error != nil {
                    
                    return
                    
                }
                
                if let safeData = data {
                    
                    let dictionary = self.parseJSON(safeData)
                    for item in dictionary {
                        self.currenciesArray.append(CurrencyModel(currencyCode: item.key, currencyRate: item.value, currencyRateStr: self.saveStringCurrencyRate(item.value), currencyName: self.currenciesNamesDictionary[item.key]))
                        
                    }
                    DispatchQueue.main.async {
                        copleted()
                    }
                    
                }
                self.currenciesArray.sort{$0.currencyName ?? "" < $1.currencyName ?? ""}
            }
            task.resume()
        }
    }
    func parseJSON(_ data: Data) -> Dictionary<String, Double> {

        let decoder = JSONDecoder()
        do {
            
            let decodedData = try decoder.decode(CurrencyData.self, from: data)
            let rates = decodedData.rates
            return rates

        } catch {
            
            print(error)
            return ["":0]
            
        }
    }
    func saveStringCurrencyRate(_ currencyRate: Double) -> String {
        
        return String(format: "%.2f",currencyRate)
        
    }
    func buildCurrenciesString(dictionary: [String:String]) -> String {
        var currenciesString: String = ""
        var index = 0
        for currency in dictionary {
            
            if index != dictionary.count-1 {
                
                currenciesString += "\(currency.key),"
                index += 1
                
            } else {
                currenciesString += "\(currency.key)"
            }
            
        }
        return currenciesString
    }
}
