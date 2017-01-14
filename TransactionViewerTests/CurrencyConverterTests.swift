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

    var conversions : [Conversion]!
    
    override func setUp() {
        super.setUp()
        conversions = try! PLISTReader(file: "rates").array()
    }
    
    func testUSDToGBP() {
        let dollars = Money(currency: "USD", amount: 1)
        let result = try! CurrencyConverter(conversions: conversions).turn(amount: dollars, currency: "GBP")
        XCTAssert(result?.amount == 0.25, "One dolar must be 0.25 GBPs")
    }
    
    func testZeroConversion() {
        let dollars = Money(currency: "GBP", amount: 1)
        let result = try! CurrencyConverter(conversions: conversions).turn(amount: dollars, currency: "GBP")
        XCTAssert(result?.amount == 1, "One GBP must be one GBP")
    }
    
    func testUnknownCurrencyTarget() {
        let dollars = Money(currency: "GBP", amount: 1)
        let result = try? CurrencyConverter(conversions: conversions).turn(amount: dollars, currency: "AAA")
        XCTAssert(result == nil, "The result must not exist if we have a unknown currency")
    }
    
    func testUnknownCurrencyOrigin() {
        let dollars = Money(currency: "AAA", amount: 1)
        let result = try? CurrencyConverter(conversions: conversions).turn(amount: dollars, currency: "GBP")
        XCTAssert(result == nil, "The result must not exist if we have a unknown currency")
    }
    
    func testThatEmptyConversionsDoesntReturnResults() {
        let dollars = Money(currency: "USD", amount: 1)
        let result = try? CurrencyConverter(conversions: []).turn(amount: dollars, currency: "GBP")
        XCTAssert(result == nil, "Unknown files should not return results")
    }
    
}
