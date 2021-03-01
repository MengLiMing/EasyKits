//
//  EasySegmentedIndicatorBaseView.swift
//  EasyKits
//
//  Created by 孟利明 on 2021/2/25.
//

import UIKit

/// 指示器
open class EasySegmentedIndicatorBaseView: UIView {
    public let config: EasySegmentedIndicatorConfig
    
    public init(config: EasySegmentedIndicatorConfig) {
        self.config = config
        super.init(frame: .zero)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 点击选中
    open func selected(from fromRect: CGRect?, to toRect: CGRect, animation: Bool) {
        
    }
    
    /// 滑动选中
    open func scroll(from fromRect: CGRect, to toRect: CGRect, progress: CGFloat) {
        
    }
}


/// 指示器配置
open class EasySegmentedIndicatorConfig {
    /// 指示器距离底部高度
    open var bottom: CGFloat = 0
    /// 所在父视图的contentSize - 内部赋值
    internal var sueperContentSize: CGSize?
    /// 所在父视图的Bounces - 内部赋值
    internal var superBounds: CGRect?
}
