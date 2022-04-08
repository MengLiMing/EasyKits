//
//  EasySegmentedBaseCell.swift
//  EasyKits
//
//  Created by 孟利明 on 2021/2/25.
//

import UIKit
import SnapKit

/// 目前只针对各方位中心位置
public enum ViewPosition {
    public enum Position {
        case top
        case left
        case right
        case bottom
        case center
    }
    
    ///  外部center没有意义，Position.center -> superView内部中心位置
    case outer(Position)
    case inner(Position)
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
        case let .outer(edge):
            return outerLayout(by: edge)
        case let .inner(edge):
            return innerLayout(by: edge)
        }
    }
    
    @discardableResult
    func superViewLayoutIfNeeded() -> Self {
        self.superview?.layoutIfNeeded()
        return self
    }
    
    fileprivate func outerLayout(by edge: ViewPosition.Position) -> Self {
        switch edge {
        case .bottom:
            return outerBottom()
        case .top:
            return outerTop()
        case .left:
            return outerLeft()
        case .right:
            return outetRight()
        case .center:
            return innerCenter()
        }
    }
    
    fileprivate func innerLayout(by edge: ViewPosition.Position) -> Self {
        switch edge {
        case .bottom:
            return innerBottom()
        case .top:
            return innerTop()
        case .left:
            return innerLeft()
        case .right:
            return innerRight()
        case .center:
            return innerCenter()
        }
    }
}

fileprivate extension ViewLayout where Self: UIView {
    func remakeConstraints(_ closure: (_ maker: ConstraintMaker, _ superview: UIView) -> Void) -> Self {
        guard let superview = self.superview else {
            return self
        }
        snp.remakeConstraints { maker in
            closure(maker, superview)
        }
        return self
    }
}

fileprivate extension ViewLayout where Self: UIView {
    func outerLeft() -> Self {
        remakeConstraints { maker, superview in
            maker.trailing.equalTo(superview.snp.leading)
            maker.centerY.equalToSuperview()
        }
    }
    
    func outetRight() -> Self {
        remakeConstraints { maker, superview in
            maker.leading.equalTo(superview.snp.trailing)
            maker.centerY.equalToSuperview()
        }
    }
    
    func outerTop() -> Self {
        remakeConstraints { maker, superview in
            maker.bottom.equalTo(superview.snp.top)
            maker.centerX.equalToSuperview()
        }
    }
    
    func outerBottom() -> Self {
        remakeConstraints { maker, superview in
            maker.top.equalTo(superview.snp.bottom)
            maker.centerX.equalToSuperview()
        }
    }
}


fileprivate extension ViewLayout where Self: UIView {
    func innerLeft() -> Self {
        remakeConstraints { maker, superview in
            maker.leading.equalTo(superview.snp.leading)
            maker.centerY.equalToSuperview()
        }
    }
    
    func innerRight() -> Self {
        remakeConstraints { maker, superview in
            maker.trailing.equalTo(superview.snp.trailing)
            maker.centerY.equalToSuperview()
        }
    }
    
    func innerTop() -> Self {
        remakeConstraints { maker, superview in
            maker.top.equalTo(superview.snp.top)
            maker.centerX.equalToSuperview()
        }
    }
    
    func innerBottom() -> Self {
        remakeConstraints { maker, superview in
            maker.bottom.equalTo(superview.snp.bottom)
            maker.centerX.equalToSuperview()
        }
    }
    
    func innerCenter() -> Self {
        remakeConstraints { maker, superview in
            maker.center.equalToSuperview()
        }
    }
}
