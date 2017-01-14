//
//  LocalContent.swift
//  TransactionViewer
//
//  Created by Julio Guzmán on 1/14/17.
//  Copyright © 2017 Julio Guzmán. All rights reserved.
//

import Foundation

class LocalContent {
    
    func convert() -> TableContent {
        let transactions = TransactionLoader.load()
        let categorizedTransactions = transactions.categorise({$0.sku})
        var cells = [Cell]()
        let conversions = try! PLISTReader(file: "rates").array()
        for (key, value) in categorizedTransactions {
            let transactionsOfThisSKU = transactions.filter({$0.sku == key})
            var insideCells = [Cell]()
            let targetCurrency = "GBP"
            
            for transaction in transactionsOfThisSKU {
                let value = Money(currency: transaction.amount.currency,
                                  amount: transaction.amount.amount)
                let valueInPounds = try! CurrencyConverter(conversions: conversions).turn(amount: value, currency: targetCurrency)
                let cell = Cell(title: "\(value.currency)\(value.amount)", description: "\(targetCurrency)\(valueInPounds!.amount)", content: nil)
                insideCells.append(cell)
            }
            
            let description = value.reduce(Float(), {
                let value = Money(currency: $1.amount.currency,
                                  amount: $1.amount.amount)
                let valueInPounds = try! CurrencyConverter(conversions: conversions).turn(amount: value, currency: targetCurrency)
                return $0 + valueInPounds!.amount
            })
            
            let tableContent = TableContent(title: "Transactions for \(key)",
                description: "Total: \(targetCurrency)\(description)",
                cells: insideCells)
            let cell = Cell(title: key, description: "\(value.count) transactions", content: tableContent)
            cells.append(cell)
        }
        return TableContent(title: "Products", description: nil, cells: cells)
    }
}
