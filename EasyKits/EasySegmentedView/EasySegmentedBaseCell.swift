//
//  EasySegmentedBaseCell.swift
//  EasyKits
//
//  Created by 孟利明 on 2021/2/25.
//

import UIKit

/// cell
open class EasySegmentedBaseCell: UICollectionViewCell {
    
    open var itemModel: EasySegmentBaseItemModel?

    
    required override public init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: 子类重写
    open func refresh(_ itemModel: EasySegmentBaseItemModel?) {
        self.itemModel = itemModel
    }
}

/// model
open class EasySegmentBaseItemModel {
    /// 当前进度
    open var percent: CGFloat = 0 {
        didSet {
            if let dynamicWidth = self.dynamicWidth {
                itemWidth = contentWidth.transfer(to: dynamicWidth, by: percent)
            }
        }
    }
    /// itemWidth
    lazy var itemWidth: CGFloat = {
       return contentWidth.transfer(to: dynamicWidth ?? contentWidth, by: percent)
    }()
    /// 设置内容的宽度
    open var contentWidth: CGFloat = 0
    /// 动态宽度， 设置此值 则cell会动态变化宽度， 未设置则取 contentWidth
    open var dynamicWidth: CGFloat?
}
