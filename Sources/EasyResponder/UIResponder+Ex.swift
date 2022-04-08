//
//  UIResponder+Ex.swift
//  EasyKit
//
//  Created by 孟利明 on 2020/9/2.
//

import UIKit

public protocol ResponderDelegate {}

fileprivate struct ResponderDelegateKey {
    static var delegate = "responder_delegate"
}

public extension ResponderDelegate where Self: UIResponder {
    /// 响应链查找遵循T的UIResponder
    /// - Parameters:
    ///   - type: 类型
    ///   - isNeedCache: 是否需要缓存，如果视图层级会发生变化则不要保存
    /// - Returns:遵循T的UIResponder
    func delegate<T>(_ type: T.Type = T.self, isNeedCache: Bool = true) -> T? {
        if isNeedCache,
           let weakWrapper = objc_getAssociatedObject(self, &ResponderDelegateKey.delegate) as? WeakWrapper<UIResponder>,
           let delegate = weakWrapper.obj as? T {
            return delegate
        }
        
        var result: T?
        var nextResponder = next
        while nextResponder != nil {
            if let delegate = nextResponder as? T {
                result = delegate
                break
            }
            nextResponder = nextResponder?.next
        }
        
        if isNeedCache,
           let result = result as? UIResponder {
            objc_setAssociatedObject(self, &ResponderDelegateKey.delegate, WeakWrapper(result), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        return result
    }
}

// Demo
//protocol Action {
//    func login()
//}
//
//class View: UIView, DelegateProvider {
//    var delegate: Action? {
//        return self.delegate()
//    }
//}
