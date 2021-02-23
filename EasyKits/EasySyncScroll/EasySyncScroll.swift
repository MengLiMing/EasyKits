//
//  SyncScrollContext.swift
//  EasyKit
//
//  Created by 孟利明 on 2020/10/16.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa

/// ScrollItem - 提供滚动视图
public protocol SyncScrollItemProtocol: NSObjectProtocol {
    var scrollView: UIScrollView { get }
}
extension SyncScrollItemProtocol where Self: UIScrollView {
    public var scrollView: UIScrollView { return self }
}
extension SyncScrollItemProtocol where Self: WKWebView {}


/// 外部需要遵循此协议 - 外部需要重写UIGestureRecognizerDelegate： shouldRecognizeSimultaneouslyWith
public protocol SyncOuterScrollProtocol: SyncScrollItemProtocol {
    func wrapGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
}
public extension SyncOuterScrollProtocol {
    /// 包装一层 - 无法通过协议扩展UIGestureRecognizerDelegate
    func wrapGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let isEqualView = gestureRecognizer.view?.isEqual(otherGestureRecognizer.view) ?? false
        if otherGestureRecognizer.view?.isInnerItem == true || isEqualView {
            return true
        }
        return false
    }
}

/// 内部需要遵循此协议
public protocol SyncInnerScrollProtocol: SyncScrollItemProtocol {}
public extension UIView {
    var isInnerItem: Bool {
        if let scrollView = self as? UIScrollView {
            if let wkwebView = scrollView.superview as? WKWebView {
                return wkwebView.isInnerItem
            }
        }
        return self is SyncInnerScrollProtocol
    }
}

/// 内部横向滑动的containerView需要遵循此协议
public protocol SyncScrollContainerProtocol: NSObjectProtocol {
    var items: [AnyObject?] { get }
    var currentItem: AnyObject? { get }
}

public extension SyncScrollContainerProtocol {
    /// 重置内部item偏移
    func resetContentOffset() {
        for item in self.items {
            if let scrollItem = item as? SyncScrollItemProtocol  {
                scrollItem.scrollView.contentOffset = .zero
            }
        }
    }
}

/// 内外scrollView的上下文
public final class SyncScrollContext {
    /// 刷新类型
    public enum RefreshType {
        /// 外部
        case outer
        /// 内部
        case inner
    }
    
    public var refreshType: RefreshType {
        didSet {
            if refreshType == .outer {
                self.resetOuterBounces(self.outerItem?.scrollView.contentOffset ?? .zero)
            }
        }
    }
    /// 最大偏移 - 悬停时的偏移量
    public var maxOffsetY: CGFloat = 0
    /// 外部偏移
    fileprivate var outerOffset: CGPoint = .zero
    /// 内部偏移
    fileprivate var innerOffset: CGPoint = CGPoint.zero
    /// 悬停状态
    fileprivate var isHover = BehaviorRelay(value: false)
    
    fileprivate var diposeBag = DisposeBag()

    public init(refreshType: RefreshType = .outer) {
        self.refreshType = refreshType
    }
    
    /// 悬停状态改变
    public var isHoverChanged: Driver<Bool> {
        return self.isHover
            .asDriver()
            .distinctUntilChanged()
    }
    
    /// 外部scrollView
    fileprivate var outerDisposeBag = DisposeBag()
    public weak var outerItem: SyncOuterScrollProtocol? {
        didSet {
            outerDisposeBag = DisposeBag()
            outerItem?.scrollView.rx
                .contentOffset
                .distinctUntilChanged()
                .bind(to: outerOffsetChanged)
                .disposed(by: outerDisposeBag)
            
            outerItem?.scrollView.rx.contentSize
                .asDriver()
                .distinctUntilChanged()
                .drive(onNext: {[weak self] _ in
                    self?.changeHover()
                })
                .disposed(by: outerDisposeBag)
        }
    }
    
    fileprivate var outerOffsetChanged: Binder<CGPoint> {
        return Binder<CGPoint>(self) { base, contentOffset in
            guard let outer = base.outerItem else {
                return
            }
            self.resetOuterBounces(contentOffset)
            
            if base.innerOffset.y > 0 {/// container内部scrollView的偏移>0 外部偏移量保持为最大偏移
                outer.scrollView.contentOffset.y = base.maxOffsetY
                base.outerOffset = outer.scrollView.contentOffset
            } else {
                base.outerOffset = contentOffset
            }
            
            base.changeHover()
        }
    }
    
    fileprivate func resetOuterBounces(_ contentOffset: CGPoint) {
        guard let outer = self.outerItem else {
            return
        }
        switch self.refreshType {
        case .inner:
            outer.scrollView.bounces = false
        case .outer:
            outer.scrollView.bounces = contentOffset.y <= (self.maxOffsetY)/2
        }
    }
    
    fileprivate func changeHover() {
        if self.outerOffset.y >= self.maxOffsetY {/// 处于悬停状态
            self.isHover.accept(true)
        } else {
            if self.isHover.value != false {
                self.containerView?.resetContentOffset()
            }
            self.isHover.accept(false)
        }
    }
    
    /// ContainerView
    public weak var containerView: SyncScrollContainerProtocol?

    /// Container内部Item
    fileprivate var innerDisposeBag = DisposeBag()
    public weak var innerItem: SyncInnerScrollProtocol? {
        didSet {
            self.innerDisposeBag = DisposeBag()
            self.innerItem?.scrollView.rx
                .contentOffset
                .distinctUntilChanged()
                .bind(to: innerOffsetChanged)
                .disposed(by: self.innerDisposeBag)
        }
    }
    fileprivate var innerOffsetChanged: Binder<CGPoint> {
        return Binder<CGPoint>(self) { base, contentOffset in
            guard let inner = base.innerItem else {
                return
            }
            switch base.refreshType {
            case .inner:
                if base.outerOffset.y < base.maxOffsetY  {
                    if base.outerOffset.y > 0 {
                        inner.scrollView.contentOffset.y = 0
                        base.innerOffset = inner.scrollView.contentOffset
                    } else {
                        inner.scrollView.contentOffset.y = min(0, contentOffset.y)
                        base.innerOffset = inner.scrollView.contentOffset
                    }
                } else {
                    base.innerOffset = contentOffset
                }
            case .outer:
                if base.outerOffset.y < base.maxOffsetY {
                    inner.scrollView.contentOffset.y = 0
                    base.innerOffset = inner.scrollView.contentOffset
                } else {
                    base.innerOffset = contentOffset
                }
            }

            base.outerItem?.scrollView.scrollsToTop = contentOffset.y <= 0
            base.innerItem?.scrollView.scrollsToTop = contentOffset.y > 0
        }
    }
}

/// 非Rx使用
public extension SyncScrollContext {
    func hoverStatusChanged(_ handler: @escaping (Bool) -> Void) {
        self.isHoverChanged.drive(onNext: {
            handler($0)
        }).disposed(by: diposeBag)
    }
}
