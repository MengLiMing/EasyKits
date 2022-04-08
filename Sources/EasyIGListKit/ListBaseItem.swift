//
//  ListBaseItem.swift
//  ShiHuiFeiZhu
//
//  Created by Ming on 2021/5/26.
//

import UIKit
import IGListKit
import Then
import RxSwift
import RxCocoa

/// cell对应的数据模型应该遵循此协议
public typealias ListBaseItemDataType = ListBaseItemTypeProvider & ListBaseItemProvider & ListBaseItemSizeProvider & Then

public class ListBaseItem: ListDiffable,
                    ListBaseItemTypeProvider,
                    ListBaseItemSizeProvider,
                    Then {
    public let data: ListBaseItemDataType
    
    public init(data: ListBaseItemDataType) {
        self.data = data
    }
    
    /// 如果需要重新计算高度 设置此值为nil
    public var itemSize: CGSize? = nil
        
    public var itemType: ListBindableCell.Type {
        return data.itemType
    }
    
    public func diffIdentifier() -> NSObjectProtocol {
        guard let data = data as? ListDiffable else {
            return ObjectIdentifier(self).debugDescription as NSString
        }
        return data.diffIdentifier()
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let data = data as? ListDiffable else {
            return true
        }
        let objectData = (object as? ListBaseItem)?.data as? ListDiffable
        return data.isEqual(toDiffableObject: objectData)
    }
    
    public func itemSize(_ sectionController: ListSectionController) -> CGSize {
        if let itemSize = self.itemSize {
            return itemSize
        }
        let size = data.itemSize(sectionController)
        itemSize = size
        return size
    }
    
    public func selectedItem(section: ListBaseSection, index: Int) {
        guard let data = self.data as? ListBaseItemSelectionHandlerProvider else {
            return
        }
        let selectedData: ListBaseItemSelectionHandlerProvider.SelectedItem = (section, self, self.data, index)
        data._itemSeletedEventClosure?(selectedData)
        data.itemSelectedHandler?(selectedData)
    }
    
    public func copySelf() -> ListBaseItem {
        return ListBaseItem(data: data)
    }
}
