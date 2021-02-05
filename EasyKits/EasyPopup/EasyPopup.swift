//
//  EasyPopup.swift
//  EasyKit
//
//  Created by 孟利明 on 2021/2/3.
//

import UIKit
import SnapKit

fileprivate class EasyPopupKey {
    static var coverView = "coverView"
}

/// 展示布局位置变化
public enum EasyPopupShowLayout {
    case leftToCenter
    case rightToCenter
    case rightToRight
    case bottomToCenter
    case bottomToBottom
    case topToCenter
    case center
}

/// 消失布局位置变化
public enum EasyPopupDismissLayout {
    case none
    case toLeft
    case toRight
    case toBottom
    case toTop
}

/// 透明度/大小变化
public enum EasyPopupTransfer {
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
    
    /// 还原
    public func restore(_ view: UIView) {
        switch self {
        case .alpha:
            view.alpha = 1
        case .zoom:
            view.transform = .identity
        case .none:
            break
        }
    }
}

/// 动画效果
public enum EasyPopupAnimation {
    case none
    case `default`(_ duration: Double)
    case spring(_ duration: Double, damping: CGFloat, velocity: CGFloat)
    
    public static var `default`: EasyPopupAnimation {
        return EasyPopupAnimation.default(0.3)
    }
    
    public static var spring: EasyPopupAnimation {
        return EasyPopupAnimation.spring(0.3, damping: 0.7, velocity: 2)
    }
    
    public func animation(_ animations: @escaping () -> Void, completion: ((Bool) -> Void)?) {
        switch self {
        case .default(let duration):
            UIView.animate(withDuration: duration, animations: {
                animations()
            }, completion: completion)
        case let .spring(duration, damping, velocity):
            UIView.animate(withDuration: duration,
                           delay: 0,
                           usingSpringWithDamping: damping,
                           initialSpringVelocity: velocity,
                           options: .curveEaseInOut,
                           animations: {
                            animations()
                           },
                           completion: completion)
        case .none:
            animations()
            completion?(true)
        }
    }
}

/// 注意实现该协议的UIView需要保证能够通过内部约束得到宽高
public protocol EasyPopupProtocol {
    /// 动画结束
    typealias Completion = () -> Void
    /// 父视图回调
    typealias LayoutHandler = (EasyPopupProtocol) -> Void
    
    var coverView: UIControl { get set }
    
    func show(_ layout: EasyPopupShowLayout,
              transfers: [EasyPopupTransfer],
              animation: EasyPopupAnimation,
              layoutHandler: LayoutHandler?,
              completion: Completion?)
    
    func dismiss(_ layout: EasyPopupDismissLayout,
                 transfers: [EasyPopupTransfer],
                 animation: EasyPopupAnimation,
                 completion: Completion?)
    
    var showInView: UIView? { get }
}

public extension EasyPopupProtocol where Self: UIView {
    var showInView: UIView? {
        return nil
    }
    
    var coverView: UIControl {
        set {
            objc_setAssociatedObject(self, &EasyPopupKey.coverView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let view = objc_getAssociatedObject(self, &EasyPopupKey.coverView) as? UIControl {
                return view
            } else {
                let view = UIControl()
                view.backgroundColor = UIColor.black.withAlphaComponent(0.65)
                objc_setAssociatedObject(self, &EasyPopupKey.coverView, view, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return view
            }
        }
    }
    
    /// 弹出
    /// - Parameters:
    ///   - layout: 动画的起始
    ///   - transfer: 现支持大小透明的变化 可以扩展
    ///   - animation: 动画的效果和时间
    ///   - layoutHandler: 动画之前 frame确定之后的回调，可以根据需求添加一些操作
    ///   - completion: 动画结束
    func show(_ layout: EasyPopupShowLayout, transfer: EasyPopupTransfer, animation: EasyPopupAnimation = .default, layoutHandler: LayoutHandler? = nil, completion: Completion? = nil) {
        show(layout, transfers: [transfer], animation: animation, layoutHandler: layoutHandler, completion: completion)
    }
    
    /// 弹出
    /// - Parameters:
    ///   - layout: 动画的起始
    ///   - transfers: 现支持大小透明的变化 可以扩展
    ///   - animation: 动画的效果和时间
    ///   - layoutHandler: 动画之前 frame确定之后的回调，可以根据需求添加一些操作
    ///   - completion: 动画结束
    func show(_ layout: EasyPopupShowLayout, transfers: [EasyPopupTransfer] = [], animation: EasyPopupAnimation = .default, layoutHandler: LayoutHandler? = nil, completion: Completion? = nil) {
        switch layout {
        case .bottomToBottom:
            self.addAllViews()?
                .outerBottom()
                .layoutSuperView(layoutHandler)
                .innerBottom()
                .showLayoutAnimation(transfers: transfers, animation: animation, completion: completion)
        case .bottomToCenter:
            self.addAllViews()?
                .outerBottom()
                .layoutSuperView(layoutHandler)
                .innerCenter()
                .showLayoutAnimation(transfers: transfers, animation: animation, completion: completion)
        case .leftToCenter:
            self.addAllViews()?
                .outerLeft()
                .layoutSuperView(layoutHandler)
                .innerCenter()
                .showLayoutAnimation(transfers: transfers, animation: animation, completion: completion)
        case .rightToCenter:
            self.addAllViews()?
                .outerRight()
                .layoutSuperView(layoutHandler)
                .innerCenter()
                .showLayoutAnimation(transfers: transfers, animation: animation, completion: completion)
        case .rightToRight:
            self.addAllViews()?
                .outerRight()
                .layoutSuperView(layoutHandler)
                .innerRight()
                .showLayoutAnimation(transfers: transfers, animation: animation, completion: completion)
        case .topToCenter:
            self.addAllViews()?
                .outerTop()
                .layoutSuperView(layoutHandler)
                .innerCenter()
                .showLayoutAnimation(transfers: transfers, animation: animation, completion: completion)
        case .center:
            self.addAllViews()?
                .innerCenter()
                .layoutSuperView(layoutHandler)
                .showLayoutAnimation(transfers: transfers, animation: animation, completion: completion)
        }
    }
    
    
    /// 消失
    /// - Parameters:
    ///   - layout: 消失去向的位置
    ///   - transfer: 现支持大小透明的变化 可以扩展
    ///   - animation: 动画类型
    ///   - completion: 动画结束
    func dismiss(_ layout: EasyPopupDismissLayout, transfer: EasyPopupTransfer, animation: EasyPopupAnimation = .default, completion: (() -> Void)? = nil) {
        dismiss(layout, transfers: [transfer], animation: animation, completion: completion)
    }
    
    /// 消失
    /// - Parameters:
    ///   - layout: 消失去向的位置
    ///   - transfers: 现支持大小透明的变化 可以扩展
    ///   - animation: 动画类型
    ///   - completion: 动画结束
    func dismiss(_ layout: EasyPopupDismissLayout, transfers: [EasyPopupTransfer] = [], animation: EasyPopupAnimation = .default, completion: (() -> Void)? = nil) {
        switch layout {
        case .toLeft:
            self.outerLeft()
                .dismissLayoutAnimation(transfers: transfers, animation: animation, completion: completion)
        case .toTop:
            self.outerTop()
                .dismissLayoutAnimation(transfers: transfers, animation: animation, completion: completion)
        case .toRight:
            self.outerRight()
                .dismissLayoutAnimation(transfers: transfers, animation: animation, completion: completion)
        case .toBottom:
            self.outerBottom()
                .dismissLayoutAnimation(transfers: transfers, animation: animation, completion: completion)
        case .none:
            self.dismissLayoutAnimation(transfers: transfers, animation: animation, completion: completion)
        }
    }
    
    fileprivate func addAllViews() -> Self? {
        guard let superView = self.showInView ?? UIApplication.shared.keyWindow else {
            return nil
        }
        superView.addSubview(self.coverView)
        self.coverView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        superView.addSubview(self)
        return self
    }
}

/// outer layout
extension EasyPopupProtocol where Self: UIView {
    /// 屏幕外左边
    @discardableResult
    fileprivate func outerLeft() -> Self {
        guard let superView = self.superview else {
            return self
        }
        self.snp.remakeConstraints { (maker) in
            maker.right.equalTo(superView.snp.left)
            maker.centerY.equalToSuperview()
        }
        return self
    }
    
    /// 屏幕外右方
    @discardableResult
    fileprivate func outerRight() -> Self {
        guard let superView = self.superview else {
            return self
        }
        self.snp.remakeConstraints { (maker) in
            maker.left.equalTo(superView.snp.right)
            maker.centerY.equalToSuperview()
        }
        return self
    }
    
    /// 屏幕外上方
    @discardableResult
    fileprivate func outerTop() -> Self {
        guard let superView = self.superview else {
            return self
        }
        self.snp.remakeConstraints { (maker) in
            maker.bottom.equalTo(superView.snp.top)
            maker.centerX.equalToSuperview()
        }
        return self
    }
    
    /// 屏幕外下方
    @discardableResult
    fileprivate func outerBottom() -> Self {
        guard let superView = self.superview else {
            return self
        }
        self.snp.remakeConstraints { (maker) in
            maker.top.equalTo(superView.snp.bottom)
            maker.centerX.equalToSuperview()
        }
        return self
    }
    
    
    @discardableResult
    fileprivate func layoutSuperView(_ layoutHandler: LayoutHandler?) -> Self {
        self.superview?.layoutIfNeeded()
        layoutHandler?(self)
        return self
    }
}

/// inner layout
extension EasyPopupProtocol where Self: UIView {
    /// 屏幕内中央
    @discardableResult
    fileprivate func innerCenter() -> Self {
        guard let _ = self.superview else {
            return self
        }
        self.snp.remakeConstraints { (maker) in
            maker.center.equalToSuperview()
        }
        return self
    }
    
    @discardableResult
    fileprivate func innerRight() -> Self {
        guard let _ = self.superview else {
            return self
        }
        self.snp.makeConstraints { (maker) in
            maker.right.equalTo(0)
            maker.centerY.equalToSuperview()
        }
        return self
    }
    
    /// 屏幕内底部
    @discardableResult
    fileprivate func innerBottom() -> Self {
        guard let _ = self.superview else {
            return self
        }
        self.snp.remakeConstraints { (maker) in
            maker.bottom.equalTo(0)
            maker.centerX.equalToSuperview()
        }
        return self
    }
}

/// Animation
extension EasyPopupProtocol where Self: UIView {
    fileprivate func showLayoutAnimation(transfers: [EasyPopupTransfer], animation: EasyPopupAnimation, completion: (() -> Void)?) {
        self.coverView.alpha = 0
        transfers.forEach { $0.transferFrom(self) }
        animation.animation({
            self.superview?.layoutIfNeeded()
            self.coverView.alpha = 1
            transfers.forEach { $0.transferTo(self) }
        }) { (_) in
            completion?()
        }
    }
    
    fileprivate func dismissLayoutAnimation(transfers: [EasyPopupTransfer], animation: EasyPopupAnimation, completion: (() -> Void)?) {
        self.coverView.alpha = 1
        transfers.forEach { $0.transferFrom(self) }
        animation.animation({
            self.superview?.layoutIfNeeded()
            self.coverView.alpha = 0
            transfers.forEach { $0.transferTo(self) }
        }) { (_) in
            completion?()
            self.coverView.removeFromSuperview()
            self.removeFromSuperview()
            transfers.forEach { $0.restore(self) }
        }
    }
}
