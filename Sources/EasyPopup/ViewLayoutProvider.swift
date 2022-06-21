//
//  ViewLayoutProvider.swift
//  EasyKits
//
//  Created by Ming on 2022/6/21.
//

import UIKit
import SnapKit

public protocol ViewLayoutProvider {
    func layoutInner<T: UIView>(view: T) -> T


    func layoutOuter<T: UIView>(view: T) -> T
}

public extension ViewLayoutProvider {
    func layoutInner<T: UIView>(view: T) -> T {
        view
    }


    func layoutOuter<T: UIView>(view: T) -> T {
        view
    }
}


public enum ViewLayoutPosition {
    public  static var top = ViewLayoutPosition.top(0)
    public static var left = ViewLayoutPosition.left(0)
    public static var right = ViewLayoutPosition.right(0)
    public static var bottom = ViewLayoutPosition.bottom(0)
    public static var center = ViewLayoutPosition.center(0, 0)

    case top(CGFloat)
    case left(CGFloat)
    case right(CGFloat)
    case bottom(CGFloat)
    
    /// 屏幕外center 此处提供实现依然为屏幕内center，如需自定义提供ViewLayoutProvider
    case center(_ horizontal: CGFloat, _ vertical: CGFloat)
}

extension ViewLayoutPosition: ViewLayoutProvider {
    public func layoutInner<T: UIView>(view: T) -> T {
        switch self {
        case .top(let value):
            return innerTop(view, value)
        case .left(let value):
            return innerLeft(view, value)
        case .right(let value):
            return innerRight(view, value)
        case .bottom(let value):
            return innerBottom(view, value)
        case .center(let horizontal, let vertical):
            return innerCenter(view, horizontal, vertical)
        }
    }


    public func layoutOuter<T: UIView>(view: T) -> T {
        switch self {
        case .top(let value):
            return outerTop(view, value)
        case .left(let value):
            return outerLeft(view, value)
        case .right(let value):
            return outetRight(view, value)
        case .bottom(let value):
            return outerBottom(view, value)
        case .center(let horizontal, let vertical):
            return innerCenter(view, horizontal, vertical)
        }
    }
}

extension ViewLayoutPosition {
    func remakeConstraints<T: UIView>(_ view: T, _ closure: (_ maker: ConstraintMaker, _ superview: UIView) -> Void) -> T {
        guard let superview = view.superview else {
            return view
        }
        view.snp.remakeConstraints { maker in
            closure(maker, superview)
        }
        return view
    }
}

extension ViewLayoutPosition {
    func outerLeft<T: UIView>(_ view: T, _ value: CGFloat = 0) -> T {
        remakeConstraints(view) { maker, superview in
            maker.trailing.equalTo(superview.snp.leading).offset(-value)
            maker.centerY.equalToSuperview()
        }
    }
    
    func outetRight<T: UIView>(_ view: T, _ value: CGFloat = 0) -> T {
        remakeConstraints(view) { maker, superview in
            maker.leading.equalTo(superview.snp.trailing).offset(value)
            maker.centerY.equalToSuperview()
        }
    }
    
    func outerTop<T: UIView>(_ view: T, _ value: CGFloat = 0) -> T {
        remakeConstraints(view) { maker, superview in
            maker.bottom.equalTo(superview.snp.top).offset(-value)
            maker.centerX.equalToSuperview()
        }
    }
    
    func outerBottom<T: UIView>(_ view: T, _ value: CGFloat = 0) -> T {
        remakeConstraints(view) { maker, superview in
            maker.top.equalTo(superview.snp.bottom).offset(value)
            maker.centerX.equalToSuperview()
        }
    }
}


extension ViewLayoutPosition {
    func innerLeft<T: UIView>(_ view: T, _ value: CGFloat = 0) -> T {
        remakeConstraints(view) { maker, superview in
            maker.leading.equalTo(superview.snp.leading).offset(value)
            maker.centerY.equalToSuperview()
        }
    }
    
    func innerRight<T: UIView>(_ view: T, _ value: CGFloat = 0) -> T {
        remakeConstraints(view) { maker, superview in
            maker.trailing.equalTo(superview.snp.trailing).offset(-value)
            maker.centerY.equalToSuperview()
        }
    }
    
    func innerTop<T: UIView>(_ view: T, _ value: CGFloat = 0) -> T {
        remakeConstraints(view) { maker, superview in
            maker.top.equalTo(superview.snp.top).offset(value)
            maker.centerX.equalToSuperview()
        }
    }
    
    func innerBottom<T: UIView>(_ view: T, _ value: CGFloat = 0) -> T {
        remakeConstraints(view) { maker, superview in
            maker.bottom.equalTo(superview.snp.bottom).offset(-value)
            maker.centerX.equalToSuperview()
        }
    }
    
    func innerCenter<T: UIView>(_ view: T, _ horizontal: CGFloat = 0, _ vertical: CGFloat = 0) -> T {
        remakeConstraints(view) { maker, superview in
            maker.centerX.equalTo(superview.snp.centerX).offset(horizontal)
            maker.centerY.equalTo(superview.snp.centerY).offset(vertical)
        }
    }
}


