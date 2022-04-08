//
//  EasySegmentedIndicatorBaseView.swift
//  EasyKits
//
//  Created by 孟利明 on 2021/2/25.
//

import UIKit

/// 指示器
open class EasySegmentedIndicatorBaseView: UIView {
    /// 所在父视图的Bounces
    internal var superBounds: CGRect = .zero
        
    /// 点击选中
    open func selected(to toRect: CGRect, animation: Bool) {
    }
    
    /// 滑动选中
    open func scroll(from fromRect: CGRect,
                     to toRect: CGRect,
                     progress: CGFloat) {
        
    }
}
