//
//  EasySegmentedBaseCell.swift
//  EasyKits
//
//  Created by 孟利明 on 2021/2/25.
//

import UIKit
import SnapKit

public enum ViewPosition {
    public static func outer(_ position: ViewLayoutPosition) -> ViewPosition {
        return .outer(provider: position)
    }
    
    public static func inner(_ position: ViewLayoutPosition) -> ViewPosition {
        return .inner(provider: position)
    }
    
    case outer(provider: ViewLayoutProvider)
    case inner(provider: ViewLayoutProvider)
}

public protocol ViewLayout {}

/// 暂时UIView遵循
extension UIView: ViewLayout { }

public extension ViewLayout where Self: UIView {
    @discardableResult
    func layout(from fromPosition: ViewPosition, to toPosition: ViewPosition) -> Self {
        layout(by: fromPosition)
            .superViewLayoutIfNeeded()
            .layout(by: toPosition)
    }
    
    @discardableResult
    func layout(by position: ViewPosition) -> Self {
        switch position {
        case let .outer(provider):
            return provider.layoutOuter(view: self)
        case let .inner(provider):
            return provider.layoutInner(view: self)
        }
    }
    
    @discardableResult
    func superViewLayoutIfNeeded() -> Self {
        self.superview?.layoutIfNeeded()
        return self
    }
}
