//
//  EasyListSectionModel.swift
//  EasyKit
//
//  Created by 孟利明 on 2020/6/28.
//

import UIKit

public final class EasyListSectionModel: NSObject {
    public weak var tableView: EasyListView?
    
    /// 分区Model 可能是一些这个分区公用的数据
    public var sectionModel: Any?
    
    public var section: Int?
    
    /// 分区cell
    public private(set) var cellModelList: [EasyListCellModel] = []
    
    /// header
    public var headerModel: EasyListHeadFootModel?
    
    /// footer
    public var footerModel: EasyListHeadFootModel?
    
    
    /// 头部高度
    public var headHeight: CGFloat {
        return self.headerModel?.viewHeight ?? EasyListHeadFootModel.minHeight
    }
    
    /// 底部高度
    public var footHeight: CGFloat {
        return self.footerModel?.viewHeight ?? EasyListHeadFootModel.minHeight
    }
    
    /// section中cell的高度
    public private(set) var cellsHeight: CGFloat = 0
}

public extension EasyListSectionModel {
    func add(cellType: EasyListCellTypeLimit, data: Any? = nil) {
        let cellModel = EasyListCellModel(cellType: cellType, data: data)
        self.add(cellModel: cellModel)
    }
    
    func add<T: EasyListViewCell>(cellType: T.Type, data: Any? = nil) {
        let cellModel = EasyListCellModel(cellType: cellType, data: data)
        self.add(cellModel: cellModel)
    }
    
    /// 添加model
    func add(cellModel: EasyListCellModel) {
        cellsHeight += cellModel.cellHeight
        cellModel.superSectionModel = self
        cellModelList.append(cellModel)
    }
    
    func add(cellModels: [EasyListCellModel]) {
        for cellModel in cellModels {
            self.add(cellModel: cellModel)
        }
    }
    
    func removeLastCell() {
        let last = cellModelList.removeLast()
        cellsHeight -= last.cellHeight
    }
    
    /// 清空model
    func removeAllCells() {
        cellModelList.removeAll()
        cellsHeight = 0
    }
    
    func removeCell(at index: Int) {
        if index >= cellModelList.count {
            return
        }
        let cell = cellModelList.remove(at: index)
        cellsHeight -= cell.cellHeight
    }
    
    func removeAll() {
        removeAllCells()
        sectionModel = nil
        footerModel = nil
    }
    
    func cellModel(atIndex index: Int) -> EasyListCellModel? {
        if self.cellModelList.count > index {
            return self.cellModelList[index]
        }
        return nil
    }
    
    func changeSectionHeightByCell(_ cellOld: CGFloat, cellNew: CGFloat) {
        if cellOld == cellNew { return }
        self.cellsHeight += (cellNew - cellOld)
    }
    
    func reloadAllCell() {
        self.cellModelList.forEach { (cellModel) in
            cellModel.isNeedResetCellData = true
            cellModel.resetCellHeight()
        }
        self.reload()
    }
    
    func reload() {
        guard let tableView = self.tableView else {
            return
        }
        if let section = self.section {
            tableView.reloadSections([section], with: .none)
        } else {
            tableView.reloadData()
        }
    }
    
    /// 整个section的高度
    func sectionHeight() -> CGFloat {
        return cellsHeight + headHeight + footHeight
    }
}
