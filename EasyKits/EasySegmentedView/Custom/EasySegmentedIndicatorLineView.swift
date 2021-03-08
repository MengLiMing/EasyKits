//
//  EasySegmentedIndicatorLineView.swift
//  EasyKits
//
//  Created by 孟利明 on 2021/3/5.
//

import UIKit

open class EasySegmentedIndicatorLineView: EasySegmentedIndicatorBaseView {
    /// 宽度 设置宽度则代表定宽 默认为0 动态取内容宽度
    open var viewWidth: CGFloat = 0
    /// 高度
    open var viewHeight: CGFloat = 2
    /// 指示器距离底部高度
    open var bottom: CGFloat = 0
    
    // MARK: Override
    open override func selected(to toRect: CGRect, animation: Bool) {
        super.selected(to: toRect, animation: animation)
        let centerX = toRect.midX
        let width = toRect.width
        self.frame = CGRect(x: centerX - width/2, y: superBounds.height-bottom-viewHeight, width: toRect.width, height: viewHeight)
    }
    
    open override func scroll(from fromRect: CGRect, to toRect: CGRect, progress: CGFloat) {
        
    }
}
