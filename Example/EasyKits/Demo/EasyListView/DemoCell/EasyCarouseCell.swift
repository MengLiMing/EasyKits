//
//  EasyCarouseCell.swift
//  EasyKits_Example
//
//  Created by 孟利明 on 2021/2/24.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import EasyKits

class EasyCarouseCell: EasyListViewCell {
    // MARK: Override
    override func bindCell(cellModel: EasyListCellModel) {
        super.bindCell(cellModel: cellModel)
        
        /// 数据源 绑定数据
        
    }
    
    /// 可以根据数据计算高度 - 会缓存高度
    override class func cellHeight(cellModel: EasyListCellModel) -> CGFloat {
        return 100
    }
}
