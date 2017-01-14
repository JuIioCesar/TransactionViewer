//
//  CurrencyConverter.swift
//  TransactionViewer
//
//  Created by Julio Guzmán on 1/14/17.
//  Copyright © 2017 Julio Guzmán. All rights reserved.
//

import Foundation

enum ConverterError: Error {
    case invaildPath
    case unexpectedPlistStructure
    case couldNotFindRate
}

class CurrencyConverter {
    
    var ratesResource : String!
    
    init(withRatesFile name: String) {
        ratesResource = name
    }
    
    private func conversions() throws -> [[String: Any]]? {
        guard ratesResource != nil else {
            throw ConverterError.invaildPath
        }
        guard let path = Bundle.main.path(forResource: ratesResource, ofType: "plist") else {
            throw ConverterError.invaildPath
        }
        guard let array = NSArray(contentsOfFile: path) as? [[String: Any]] else {
            throw ConverterError.unexpectedPlistStructure
        }
        return array
    }
    
    private func getRoute(from currency: String, to targetCurrency: String) throws -> [String]? {
        let conversions = try self.conversions()
        let graph = AdjacencyMatrixGraph<String>()
        
        for conversion in conversions! {
            guard let from = conversion["from"] as? String else {
                continue
            }
            guard let to = conversion["to"] as? String else {
                continue
            }
            guard let _ = conversion["rate"] as? String else {
                continue
            }
            
            let fromVertex = graph.createVertex(from)
            let toVertex = graph.createVertex(to)
            graph.addDirectedEdge(fromVertex, to: toVertex, withWeight: 0)
        }
        
        let result = FloydWarshall<Int>.apply(graph)
        let from = graph.createVertex(currency)
        let to = graph.createVertex(targetCurrency)
        return result.path(fromVertex: from, toVertex: to, inGraph: graph)
    }
    
    func rate(currencyA: String, currencyB: String) -> Float? {
        guard let conversions = try? self.conversions() else {
            return nil
        }
        for conversion in conversions! {
            guard let from = conversion["from"] as? String else {
                continue
            }
            guard let to = conversion["to"] as? String else {
                continue
            }
            guard let rate = conversion["rate"] as? String else {
                continue
            }
            if from == currencyA && to == currencyB {
                return Float(rate)
            }
        }
        return nil
    }
    
    func turn(amount : Money, currency: String) throws -> Money? {
        guard amount.currency != currency else {
            return amount
        }
        guard let route = try? getRoute(from: amount.currency, to: currency ) else {
            throw ConverterError.couldNotFindRate
        }
        if route == nil {
            throw ConverterError.couldNotFindRate
        }
        var result = amount.amount
        var unwrappedRoute = route!
        for index in 0...unwrappedRoute.count - 2 {
            let nextIndex = index + 1
            guard let currentRate = rate(currencyA: unwrappedRoute[index], currencyB: unwrappedRoute[nextIndex]) else {
                throw ConverterError.couldNotFindRate
            }
            result = result * currentRate
        }
        
        return Money(currency: currency, amount: result)
    }
    
}
