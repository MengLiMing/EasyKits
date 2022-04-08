//
//  EasyListViewRegister.swift
//  EasyKit
//
//  Created by 孟利明 on 2020/6/28.
//

import UIKit

protocol EasyListViewRegisterCellProtocol {
    func registerCellID() -> String
    func registerCellClass() -> UITableViewCell.Type
}

protocol EasyListViewRegisterViewProtocol {
    func registerViewID() -> String
    func registerViewClass() -> UITableViewHeaderFooterView.Type
}

class EasyListViewRegister: NSObject {
    weak var tableView: UITableView?
    
    fileprivate var cellIDs: Set<String> = []
    fileprivate var viewIDs: Set<String> = []
    
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
    }
    
    func registerCell(cellModel: EasyListViewRegisterCellProtocol) {
        guard let tableView = self.tableView else {
            return
        }
        
        let cellID = cellModel.registerCellID()
        if cellIDs.contains(cellID) {
            return
        }
        
        tableView.register(cellModel.registerCellClass(), forCellReuseIdentifier: cellID)
        cellIDs.insert(cellID)
    }
    
    
    func registerHeaderFooter(viewModel: EasyListViewRegisterViewProtocol) {
        guard let tableView = self.tableView else {
            return
        }
        
        let viewID = viewModel.registerViewID()
        if viewIDs.contains(viewID) {
            return
        }
        tableView.register(viewModel.registerViewClass(), forHeaderFooterViewReuseIdentifier: viewID)
        viewIDs.insert(viewID)
    }
}
