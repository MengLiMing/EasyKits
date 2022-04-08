//
//  SyncScrollProvider.swift
//  NiceTuanUIComponents
//
//  Created by Ming on 2021/8/23.
//

import UIKit
import WebKit

public protocol SyncScrollProvider: AnyObject {
    var scrollView: UIScrollView { get }
}

extension SyncScrollProvider where Self: UIScrollView {
    public var scrollView: UIScrollView { return self }
}

extension SyncScrollProvider where Self: WKWebView {}


/// 内部需要遵循此协议
public protocol SyncInnerScroll: SyncScrollProvider {}

/// inner提供者 如果提供的UIScrollView可能是UIViewController
public protocol SyncScrollInnerProvider {
    var syncInner: SyncInnerScroll { get }
}

/// 外部需要遵循此协议 - 外部需要重写UIGestureRecognizerDelegate： shouldRecognizeSimultaneouslyWith
public protocol SyncOuterScroll: SyncScrollProvider {
    func wrapGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
}

public extension SyncOuterScroll {
    /// 包装一层 - 无法通过协议扩展UIGestureRecognizerDelegate
    func wrapGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let isEqualView = gestureRecognizer.view?.isEqual(otherGestureRecognizer.view) ?? false
        if otherGestureRecognizer.view?.isInnerItem == true || isEqualView {
            return true
        }
        return false
    }
}

fileprivate extension UIView {
    var isInnerItem: Bool {
        if let scrollView = self as? UIScrollView {
            if let wkwebView = scrollView.superview as? WKWebView {
                return wkwebView.isInnerItem
            }
        }
        return self is SyncInnerScroll
    }
}
