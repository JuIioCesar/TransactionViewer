//
//  File.swift
//  TransactionViewer
//
//  Created by Julio Guzmán on 1/14/17.
//  Copyright © 2017 Julio Guzmán. All rights reserved.
//

import Foundation

class TableViewViewModel {
    private var content : TableContent!
    init(with tableContent: TableContent) {
        content = tableContent
    }
    
    lazy var title: String? = {
        return self.content.title
    }()
    
    lazy var description: String? = {
        return self.content.description
    }()
    
    lazy var titles: [String] = {
        var titles = [String]()
        guard self.content.cells != nil else {
            return []
        }
        for cell in self.content.cells! {
            titles.append(cell.title)
        }
        return titles
    }()
    
    lazy var descriptions: [String] = {
        var descriptions = [String]()
        guard self.content.cells != nil else {
            return []
        }
        for cell in self.content.cells! {
            descriptions.append(cell.description)
        }
        return descriptions
    }()
    
    lazy var contents: [AnyObject] = {
        var contents = [AnyObject]()
        guard self.content.cells != nil else {
            return []
        }
        for cell in self.content.cells! {
            if cell.content == nil {
                contents.append(NSNull())
            } else {
                contents.append(cell.content as AnyObject)
            }
            
        }
        return contents
    }()
}
