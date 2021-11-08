//
//  ListEmptyItem.swift
//  ShiHuiFeiZhu
//
//  Created by Ming on 2021/5/22.
//

import Foundation
import IGListKit

public class ListEmptyItem: ListBaseItemDataType,
                     ListBaseItemCornerProvider,
                     ListBaseItemSeparatorStyleProvider {
    
    public var separatorStyle: ListItemSeparatorStyle = .none()
    
    public let itemHeight: CGFloat
    
    public let bgColor: UIColor
    
    public var corner: CornerConfig = .none

    public init(bgColor: UIColor = .clear, itemHeight: CGFloat = 0) {
        self.bgColor = bgColor
        self.itemHeight = itemHeight
    }
    
    public var itemType: ListBindableCell.Type {
        return ListEmptyCell.self
    }
    
    public func itemSize(_ sectionController: ListSectionController) -> CGSize {
        return .init(width: sectionController.contentWidth, height: itemHeight)
    }
}

class ListEmptyCell: ListSeparatorBindableDataCell<ListEmptyItem> {
    override func bindData(_ data: ListEmptyItem) {
        super.bindData(data)
        contentView.backgroundColor = data.bgColor
    }
}
