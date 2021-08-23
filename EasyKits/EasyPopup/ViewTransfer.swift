//
//  EasySegmentedBaseCell.swift
//  EasyKits
//
//  Created by 孟利明 on 2021/2/25.
//

import UIKit

/// 透明度/大小变化
public enum ViewTransfer {
    case none
    case alpha(from: CGFloat, to: CGFloat)
    case zoom(from: CGFloat, to: CGFloat)
    
    public func transferFrom(_ view: UIView) {
        transfer(view, isInit: true)
    }
    
    public func transferTo(_ view: UIView) {
        transfer(view, isInit: false)
    }
    
    private func transfer(_ view: UIView, isInit: Bool) {
        switch self {
        case let .alpha(from, to):
            view.alpha = isInit ? from : to
        case let .zoom(from, to):
            view.transform = isInit ? CGAffineTransform(scaleX: from, y: from) : CGAffineTransform(scaleX: to, y: to)
        case .none:
            break
        }
    }
}
