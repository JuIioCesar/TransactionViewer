//
//  PLISTReader.swift
//  TransactionViewer
//
//  Created by Julio Guzmán on 1/14/17.
//  Copyright © 2017 Julio Guzmán. All rights reserved.
//

import Foundation

enum ReadPlistError: Error {
    case invaildPath
    case unexpectedPlistStructure
}

class PLISTReader {
    private var resource : String?
    init(file name: String) {
        resource = name
    }
    
    func array() throws -> [[String: Any]] {
        guard resource != nil else {
            throw ReadPlistError.invaildPath
        }
        guard let path = Bundle.main.path(forResource: resource, ofType: "plist") else {
            throw ReadPlistError.invaildPath
        }
        guard let array = NSArray(contentsOfFile: path) as? [[String: Any]] else {
            throw ReadPlistError.unexpectedPlistStructure
        }
        return array
    }
    
}
