//
//  EasySegmentBaseItemModel.swift
//  EasyKits
//
//  Created by 孟利明 on 2021/2/25.
//

import Foundation

open class EasySegmentBaseItemModel {
    /// 当前进度
    open var percent: CGFloat = 0 {
        didSet {
            if let dynamicWidth = self.dynamicWidth {
                itemWidth = contentWidth + (dynamicWidth - contentWidth) * percent
            }
        }
    }
    /// itemWidth
    lazy var itemWidth: CGFloat = {
       return contentWidth
    }()
    /// 设置内容的宽度
    open var contentWidth: CGFloat = 0
    /// 动态宽度， 设置此值 则cell会动态变化宽度， 未设置则取 contentWidt
    open var dynamicWidth: CGFloat?
}
