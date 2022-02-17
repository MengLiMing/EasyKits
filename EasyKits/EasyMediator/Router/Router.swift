//
//  Router.swift
//  EasyKits
//
//  Created by Ming on 2022/2/17.
//

import Foundation

public enum RouterError: Error {
    /// 拒绝
    case reject
    /// 异常
    case exception
    /// 未找到方法
    case noAction
}


public let routerCallback = "callback"

/// 字典中取回调
public extension Dictionary where Key == String {
    var routerCallBack: Router.CallBack? {
        return self[routerCallback] as? Router.CallBack
    }
}

public final class Router: NSObject {
    public typealias CallBack = (_ error: Error?, _ message: String?, _ args: Any?) -> Void
    
    public static var shared: Router {
        struct Singleton {
            static let share = Router()
        }
        return Singleton.share
    }
    
    /// 路由Target分发 - 各模块可以使用extension扩展
    fileprivate lazy var target = RouterTarget()
    
    fileprivate override init() {}
}

public extension Router {    
    func performTarget(
        action: String?,
        parameter: [String: Any]? = nil,
        interceptorNode: InterceptorNode? = nil,
        callBack: CallBack? = nil
    ) {
        if let interceptorNode = interceptorNode {
            interceptorNode.intercept {
                self.performTarget(action: action, parameter: parameter, interceptorNode: nil, callBack: callBack)
            }
            return
        }
        guard let action = action else {
            callBack?(RouterError.exception, nil, nil)
            return
        }
        
        var params = parameter ?? [:]
        if let callBack = callBack {
            params[routerCallback] = callBack
        }

        target.perform(action: action, params: params)
        return
    }
}
