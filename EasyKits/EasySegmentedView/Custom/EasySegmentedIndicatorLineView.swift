//
//  EasySegmentedIndicatorLineView.swift
//  EasyKits
//
//  Created by 孟利明 on 2021/3/5.
//

import UIKit

open class EasySegmentedIndicatorLineView: EasySegmentedIndicatorBaseView {
    /// 宽度
    public enum LineWidth {
        /// 固定宽度
        case fixed(CGFloat)
        /// 跟随选中item变化
        case bySelected
    }
    /// 动画样式
    public enum LineAnimation {
        /// 无动画
        case none
        /// 0-0.5 首位到前后item的中心点，0.5-1 回到结束状态
        case toCenterToEnd
    }
    
    open var lineWidth: LineWidth = .bySelected
    
    open var lineAnimation: LineAnimation = .toCenterToEnd
    /// 高度
    open var viewHeight: CGFloat = 2
    /// 指示器距离底部高度
    open var bottom: CGFloat = 0
    
    // MARK: Override
    open override func selected(to toRect: CGRect, animation: Bool) {
        super.selected(to: toRect, animation: animation)
        let toFrame = self.rect(to: toRect, progress: 1)
        UIView.animate(withDuration: animation ? 0.25 : 0) {
            self.frame = toFrame
        }
    }
    
    open override func scroll(from fromRect: CGRect, to toRect: CGRect, progress: CGFloat) {
        self.frame = rect(from: fromRect, to: toRect, progress: progress)
    }
}

fileprivate extension EasySegmentedIndicatorLineView {
    func rect(from fromRect: CGRect = .zero, to toRect: CGRect, progress: CGFloat) -> CGRect {
        switch lineAnimation {
        case .none:
            return animationNone(from: fromRect, to: toRect, progress: progress)
        case .toCenterToEnd:
            return toCenterToEnd(from: fromRect, to: toRect, progress: progress)
        }
    }
    
    func animationNone(from fromRect: CGRect = .zero, to toRect: CGRect, progress: CGFloat) -> CGRect {
        let widthWrapper = width(from: fromRect, to: toRect)
        let width = widthWrapper.fromWidth.transfer(to: widthWrapper.toWidth, by: progress)
        let centerX = fromRect.midX.transfer(to: toRect.midX, by: progress)

        return CGRect(x: centerX - width/2, y: superBounds.height-bottom-viewHeight, width: width, height: viewHeight)
    }
    
    func toCenterToEnd(from fromRect: CGRect = .zero, to toRect: CGRect, progress: CGFloat) -> CGRect {
        let widthWrapper = width(from: fromRect, to: toRect)
        
        let startCenterX = fromRect.midX
        let middleCenterX = fromRect.midX + (toRect.midX - fromRect.midX)/2
        let endCenterX = toRect.midX
        
        let startWidth = widthWrapper.fromWidth
        let middleWidth = abs(toRect.midX - fromRect.midX)
        let endWidth = widthWrapper.toWidth
        
        var centerX: CGFloat
        var width: CGFloat
        if progress <= 0.5 {
            centerX = startCenterX.transfer(to: middleCenterX, by: progress*2)
            width = startWidth.transfer(to: middleWidth, by: progress*2)
        } else {
            centerX = middleCenterX.transfer(to: endCenterX, by: (progress - 0.5)*2)
            width = middleWidth.transfer(to: endWidth, by: (progress - 0.5)*2)
        }
        return CGRect(x: centerX - width/2, y: superBounds.height-bottom-viewHeight, width: width, height: viewHeight)
    }
    
    typealias WidthWrapper = (fromWidth: CGFloat, toWidth: CGFloat)
    func width(from fromRect: CGRect = .zero, to toRect: CGRect) -> WidthWrapper {
        var fromWidth: CGFloat = 0
        var toWidth: CGFloat = 0
        switch lineWidth {
        case let .fixed(width):
            fromWidth = width
            toWidth = width
        case .bySelected:
            fromWidth = fromRect.width
            toWidth = toRect.width
        }
        return (fromWidth, toWidth)
    }
}
