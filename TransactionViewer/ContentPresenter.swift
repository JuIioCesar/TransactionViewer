//
//  LocalContentPresenter.swift
//  TransactionViewer
//
//  Created by Julio Guzmán on 1/14/17.
//  Copyright © 2017 Julio Guzmán. All rights reserved.
//

import Foundation
import UIKit

class ContentPresenter {
    class func presentContentWith(_ window : UIWindow) {
        guard let navigation = window.rootViewController as? UINavigationController else {
            return
        }
        
        guard let view = navigation.viewControllers.first as? TableViewController else {
            return
        }
        
        let content = LocalContent().convert()
        let viewModel = TableViewViewModel(with: content)
        view.updateWith(viewModel: viewModel)
    }
}
