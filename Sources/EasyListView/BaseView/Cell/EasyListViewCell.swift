//
//  EasyListViewCell.swift
//  EasyKit
//
//  Created by 孟利明 on 2020/6/28.
//

import UIKit

open class EasyListViewCell: UITableViewCell {
    public var cellModel: EasyListCellModel?
    
    public weak var listView: EasyListView?
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .white
        self.clipsToBounds = true
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public final func updateCellHeight() {
        guard let listView = self.listView else {
            return
        }
        if #available(iOS 11.0, *) {
            listView.performBatchUpdates(nil, completion: nil)
        } else {
            listView.beginUpdates()
            listView.endUpdates()
        }
    }
    
    /// 重新计算高度 - 此方法通过cellHeight(cellModel: EasyListCellModel)得到最新高度
    public final func resetCellHeight() {
        self.cellModel?.resetCellHeight()
        self.updateCellHeight()
    }
    
    /// 重新设置高度
    public final func resetCellHeight(_ height: CGFloat) {
        self.cellModel?.resetCellHeight(height)
        self.updateCellHeight()
    }
    
    /// 数据绑定
    open func bindCell(cellModel: EasyListCellModel) {
        self.cellModel = cellModel
    }
    
    /// 子类需要重写 返回高度
    open class func cellHeight(cellModel: EasyListCellModel) -> CGFloat {
        return 0
    }
    
    /// 是否需要重新绑定数据 - 根据需求自行判断
    public final func isCanRefreshCell(cellModel: EasyListCellModel) -> Bool {
        return !cellModel.isEqual(self.cellModel) || cellModel.isNeedResetCellData
    }
    
    public final func isCannotRefreshCell(cellModel: EasyListCellModel) -> Bool {
        return !self.isCanRefreshCell(cellModel: cellModel)
    }
    
    public static func defaultLimit() -> EasyListCellLimit<EasyListViewCell> {
        return EasyListCellLimit<EasyListViewCell>()
    }
}


