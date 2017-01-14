//
//  ConversionLoader.swift
//  TransactionViewer
//
//  Created by Julio Guzmán on 1/14/17.
//  Copyright © 2017 Julio Guzmán. All rights reserved.
//

import Foundation

class ConversionLoader {
    class func load() -> [Conversion] {
        var conversions = [Conversion]()
        guard let arrayFromPLIST = try? PLISTReader(file: "rates").array() else {
            return []
        }
        
        for conversion in arrayFromPLIST {
            guard let _ = conversion["from"] as? String else {
                continue
            }
            guard let _ = conversion["to"] as? String else {
                continue
            }
            guard let _ = conversion["rate"] as? String else {
                continue
            }
            
            conversions.append(conversion)
        }
        
        return conversions
    }
}
