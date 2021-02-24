//
//  EasyListOtherCell.swift
//  EasyKits_Example
//
//  Created by 孟利明 on 2021/2/24.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import EasyKits

struct EasyListOtherModel {
    var bgColor: UIColor
    var height: CGFloat
}

class EasyListOtherCell: EasyListViewCell {
    override func bindCell(cellModel: EasyListCellModel) {
        if cellModel.isEqual(self.cellModel) { return }
        super.bindCell(cellModel: cellModel)
        guard let model = cellModel.data as? EasyListOtherModel else {
            return
        }
        self.contentView.backgroundColor = model.bgColor
    }
    
    override class func cellHeight(cellModel: EasyListCellModel) -> CGFloat {
        guard let model = cellModel.data as? EasyListOtherModel else {
            return 0
        }
        return model.height
    }
}
