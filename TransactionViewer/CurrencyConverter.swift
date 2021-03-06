//
//  CurrencyConverter.swift
//  TransactionViewer
//
//  Created by Julio Guzmán on 1/14/17.
//  Copyright © 2017 Julio Guzmán. All rights reserved.
//

import Foundation

enum ConverterError: Error {
    case couldNotFindRate
}

struct Conversion {
    var from : String
    var to : String
    var rate : Float
}

class CurrencyConverter {
    
    private var conversions : [Conversion]
    
    init(conversions array : [Conversion]) {
        conversions = array
    }
    
    private func getRoute(from currency: String, to targetCurrency: String) throws -> [String]? {
        let graph = AdjacencyMatrixGraph<String>()
        
        for conversion in conversions {
            let from = conversion.from
            let to = conversion.to
            let fromVertex = graph.createVertex(from)
            let toVertex = graph.createVertex(to)
            graph.addDirectedEdge(fromVertex, to: toVertex, withWeight: 0)
        }
        
        let result = FloydWarshall<Int>.apply(graph)
        let from = graph.createVertex(currency)
        let to = graph.createVertex(targetCurrency)
        return result.path(fromVertex: from, toVertex: to, inGraph: graph)
    }
    
    private func rate(currencyA: String, currencyB: String) -> Float? {
        for conversion in conversions {
            if conversion.from == currencyA && conversion.to == currencyB {
                return conversion.rate
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
