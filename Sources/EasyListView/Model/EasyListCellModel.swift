//
//  EasyListCellModel.swift
//  EasyKit
//
//  Created by 孟利明 on 2020/6/28.
//

import UIKit

public final class EasyListCellModel: NSObject {
    public typealias SelectedHandler = (EasyListCellModel) -> ()
    
    /// 每个cell需要数据
    public var data: Any?
    
    public var indexPath: IndexPath?
    
    /// cellType
    public private(set) var cellType: EasyListCellTypeLimit
    
    /// 父分区
    public weak var superSectionModel: EasyListSectionModel?
    
    /// cellClass
    public private(set) lazy var cellClass: EasyListViewCell.Type = {
        return self.cellType.cellClass()
    }()
    
    /// cellID
    public private(set) lazy var cellID: String = {
        return self.cellType.cellID()
    }()
    
    /// cellHeight
    public private(set) lazy var cellHeight: CGFloat = {
        return self.cellClass.cellHeight(cellModel: self)
    }()
    
    public init(cellType: EasyListCellTypeLimit, data: Any? = nil) {
        self.cellType = cellType
        self.data = data
        super.init()
    }
    
    public init<T: EasyListViewCell>(cellType: T.Type, data: Any? = nil) {
        self.cellType = EasyListCellLimit<T>()
        self.data = data
        super.init()
    }
    
    /// 数据需要重新绑定Cell数据 默认为false
    public var isNeedResetCellData: Bool = false
    
    public class func empty() -> EasyListCellModel {
        return EasyListCellModel(cellType: EasyListViewCell.self, data: nil)
    }
    
    public var selectedHandler: SelectedHandler?
}

public extension EasyListCellModel {
    /// 重新设置高度
    /// - Parameters:
    ///   - height: 新高度
    func resetCellHeight(_ height: CGFloat) {
        let old = self.cellHeight
        self.cellHeight = height
        self.superSectionModel?.changeSectionHeightByCell(old, cellNew: height)
    }
    
    /// 重新计算高度
    func resetCellHeight() {
        let newHeight = self.cellClass.cellHeight(cellModel: self)
        self.resetCellHeight(newHeight)
    }
    
    /// 刷新cell
    func reloadCell(_ height: CGFloat) {
        self.isNeedResetCellData = true
        self.resetCellHeight(height)
        self.reload()
    }
    
    /// 刷新cell
    func reloadCell() {
        self.isNeedResetCellData = true
        self.resetCellHeight()
        self.reload()
    }
    
    func reload() {
        guard let tableView = self.superSectionModel?.tableView else {
            return
        }
        if let indexPath = self.indexPath,
           let _ = tableView.cellForRow(at: indexPath) as? EasyListViewCell {
            tableView.reloadRows(at: [indexPath], with: .none)
        } else {
            tableView.reloadData()
        }
    }
}

extension EasyListCellModel: EasyListViewRegisterCellProtocol {
    func registerCellID() -> String {
        return self.cellID
    }
    
    func registerCellClass() -> UITableViewCell.Type {
        return self.cellClass
    }
}
