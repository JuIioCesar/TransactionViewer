//
//  TransactionViewerTests.swift
//  TransactionViewerTests
//
//  Created by Julio Guzmán on 1/14/17.
//  Copyright © 2017 Julio Guzmán. All rights reserved.
//

import XCTest
@testable import TransactionViewer

class CurrencyConverterTests: XCTestCase {
    func testExample() {
        let dollars = Money(currency: "USD", amount: 1)
        let result = try! CurrencyConverter.turn(amount: dollars, currency: "GBP")
        XCTAssert(result?.amount == 0.25, "One dolar must be 0.25 GBPs")
    }
    
    func testZeroConversion() {
        let dollars = Money(currency: "GBP", amount: 1)
        let result = try! CurrencyConverter.turn(amount: dollars, currency: "GBP")
        XCTAssert(result?.amount == 1, "One dolar must be 0.25 GBPs")
    }
}
