//
//  TransactionLoader.swift
//  TransactionViewer
//
//  Created by Julio Guzmán on 1/14/17.
//  Copyright © 2017 Julio Guzmán. All rights reserved.
//

import Foundation

class TransactionLoader {
    class func load() -> [Transaction] {
        var transactions = [Transaction]()
        guard let arrayFromPLIST = try? PLISTReader(file: "transactions").array() else {
            return []
        }
        
        for transaction in arrayFromPLIST {
            guard let currency = transaction["currency"] as? String else {
                continue
            }
            guard let amountString = transaction["amount"] as? String else {
                continue
            }
            guard let amount = Float(amountString) else {
                continue
            }
            guard let sku = transaction["sku"] as? String else {
                continue
            }
            let money = Money(currency: currency,
                              amount: amount )
            let transaction = Transaction(amount: money, sku: sku)
            transactions.append(transaction)
        }
        
        return transactions
    }
}
