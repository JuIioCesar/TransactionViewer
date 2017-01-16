//
//  ConversionLoader.swift
//  TransactionViewer
//
//  Created by Julio Guzmán on 1/14/17.
//  Copyright © 2017 Julio Guzmán. All rights reserved.
//

import Foundation

class ConversionLoader {
    class func loadFrom(file: String) -> [Conversion] {
        var conversions = [Conversion]()
        guard let arrayFromPLIST = try? PLISTReader(file: file).array() else {
            return []
        }
        
        for conversionDictionary in arrayFromPLIST {
            
            guard let from = conversionDictionary["from"] as? String else {
                continue
            }
            guard let to = conversionDictionary["to"] as? String else {
                continue
            }
            guard let rateString = conversionDictionary["rate"] as? String else {
                continue
            }
            guard let rate = Float(rateString) else {
                continue
            }
            
            let conversion = Conversion(from: from, to: to, rate: rate)
            conversions.append(conversion)
        }
        
        return conversions
    }
}
