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
