//
//  CurrencyManagerTest.swift
//  Currency ConverterTests
//
//  Created by Iurii Chernovalov on 17.05.21.
//

import XCTest
@testable import Currency_Converter

class CurrencyManagerTest: XCTestCase {
    
    var currencyManager: CurrencyManager!
    
    override func setUp() {
        currencyManager = CurrencyManager.shared
    }
    override func tearDown() {
        currencyManager = nil
    }

    func testParseExchangeRatesViaJSONFile() throws {
        
        guard let pathString = Bundle(for: type(of: self)).path(forResource: "currency", ofType: "json") else {
            fatalError("json not found")
        }
        
        guard let json = try? String(contentsOfFile: pathString, encoding: .utf8)
        else {
            fatalError("Unable to convert json to String")
        }
        
        let jsonData = json.data(using: .utf8)!
        let currencyData = currencyManager.parseJSON(jsonData)
        XCTAssertEqual(9.3475, currencyData["HKD"])
        XCTAssertNil(currencyData["RU"])
    }
    
    func testCurrenciesArrayIsNotNill() throws{
        let currencyURL = "http://api.exchangeratesapi.io/v1/"
        let accessKey = "a566017f079583a86b95ab3ec05572c0"
        let urlString = "\(currencyURL)latest?access_key=\(accessKey)&base=EUR&symbols=DKK,ISK,TRY,SEK,RON,MXN,HKD,CHF,THB,NOK,AUD,ILS,RUB,BRL,IDR,HUF,ZA"
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            _ = session.dataTask(with: url) { (data, response, error) in
                
                if error != nil {
                    
                    return
                    
                }
            
                    XCTAssertNotNil(data)
                        
                    
                }
            }
        }

    
        
}
