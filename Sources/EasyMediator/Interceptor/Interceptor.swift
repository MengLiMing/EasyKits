//
//  Interceptor.swift
//  Mediator
//
//  Created by Ming on 2021/11/3.
//

import Foundation
import RxSwift

/// 拦截器
public protocol Interceptor {
    typealias Next = () -> Void
    
    static func intercept(_ next: @escaping Next)
}

public extension Interceptor {
    static func link(_ other: Interceptor.Type) -> InterceptorNode {
        return InterceptorNode(self).link(other)
    }
}

/// 拦截器单链
public class InterceptorNode {
    public var value: Interceptor.Type
    
    public var nextNode: InterceptorNode?
    
    public init(_ value: Interceptor.Type) {
        self.value = value
    }
    
    @discardableResult
    public func link(_ next: Interceptor.Type) -> InterceptorNode {
        let node = InterceptorNode(next)
        self.nextNode = node
        return node
    }
}

public extension InterceptorNode {
    static func intercept(by node: InterceptorNode?, next: @escaping Interceptor.Next) {
        guard let node = node else {
            next()
            return
        }
        node.value.intercept {
            InterceptorNode.intercept(by: node.nextNode, next: next)
        }
    }

    func intercept(next: @escaping Interceptor.Next) {
        InterceptorNode.intercept(by: self, next: next)
    }
}

public extension Optional where Wrapped: InterceptorNode {
    func intercept(next: @escaping Interceptor.Next) {
        guard let value = self else {
            next()
            return
        }
        InterceptorNode.intercept(by: value, next: next)
    }
}

public extension Array where Element == Interceptor.Type {
    var interceptorNode: InterceptorNode? {
        if self.count == 0 {
            return nil
        }
        
        let node = InterceptorNode(first!)
        for value in self.dropFirst() {
            node.link(value)
        }
        return node
    }
}

public extension Reactive where Base: Interceptor {
    static var intercept: Observable<Void> {
        return Observable.create { observer in
            Base.intercept {
                observer.onNext(())
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}

extension InterceptorNode: ReactiveCompatible { }
public extension Reactive where Base: InterceptorNode {
    var intercept: Observable<Void> {
        return Observable.create { [weak base] observer in
            base.intercept {
                observer.onNext(())
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
