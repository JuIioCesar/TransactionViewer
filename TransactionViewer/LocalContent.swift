//
//  LocalContent.swift
//  TransactionViewer
//
//  Created by Julio Guzmán on 1/14/17.
//  Copyright © 2017 Julio Guzmán. All rights reserved.
//

import Foundation

class LocalContent {
    
    let targetCurrency = "GBP"
    var conversions = ConversionLoader.load()
    let transactions = TransactionLoader.load()
    
    func convert() -> TableContent {
        if conversions.count == 0 || transactions.count == 0 {
            return TableContent(title: "There´s no data to display 😢", description: "Sorry about that!", cells: nil)
        }
        
        let categorizedTransactions = transactions.categorise({$0.sku})
        
        var cells = [Cell]()
        for (sku, transactions) in categorizedTransactions {
            let transactionsOfThisSKU = transactions.filter({$0.sku == sku})
            var insideCells = [Cell]()
            for transaction in transactionsOfThisSKU {
                let value = Money(currency: transaction.amount.currency,
                                  amount: transaction.amount.amount)
                guard let valueInPounds = try? CurrencyConverter(conversions: conversions).turn(amount: value, currency: targetCurrency) else {
                    continue
                }

                let cell = Cell(title: "\(value.currency)\(value.amount)",
                          description: "\(targetCurrency)\(valueInPounds!.amount)",
                              content: nil)
                insideCells.append(cell)
            }
            
            let description = descriptionFor(transactions)
            let tableContent = TableContent(title: "Transactions for \(sku)",
                                      description: description,
                                            cells: insideCells)
            let cell = Cell(title: sku,
                      description: "\(transactions.count) transactions",
                          content: tableContent)
            cells.append(cell)
        }
        return TableContent(title: "Products", description: nil, cells: cells)
    }
    
    private func descriptionFor(_ transactions : [Transaction]) -> String {
        let description = transactions.reduce(Float(), {
            let value = Money(currency: $1.amount.currency,
                              amount: $1.amount.amount)
            let valueInPounds = try? CurrencyConverter(conversions: conversions).turn(amount: value, currency: targetCurrency)
            let sum = valueInPounds??.amount ?? 0
            return $0 + sum
        })
        return "Total: \(targetCurrency)\(description)"
    }
}
