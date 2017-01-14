//
//  ViewController.swift
//  TransactionViewer
//
//  Created by Julio Guzmán on 1/14/17.
//  Copyright © 2017 Julio Guzmán. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var model : TableViewViewModel?
    
    func updateWith(viewModel: TableViewViewModel) {
        model = viewModel
        title = model?.title
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard model != nil else {
            return 0
        }
        
        return model!.titles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard model != nil else {
            return UITableViewCell()
        }
        
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier:nil)
        cell.textLabel?.text = model!.titles[indexPath.row]
        cell.detailTextLabel?.text = model?.descriptions[indexPath.row]
        if model?.contents[indexPath.row] is NSNull {
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
         return model?.description
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if model?.contents[indexPath.row] is NSNull {
            return
        }
        else {
            let viewController = TableViewController()
            let tableContent = (model?.contents[indexPath.row])! as! TableContent
            let viewModel = TableViewViewModel(with: tableContent)
            viewController.updateWith(viewModel: viewModel )
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}



