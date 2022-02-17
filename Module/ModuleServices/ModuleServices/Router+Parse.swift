//
//  Router+Parse.swift
//  ModuleServices
//
//  Created by Ming on 2022/2/17.
//

import Foundation
import EasyKits

public extension Router {
    func router(_ urlString: String?, callBack: CallBack? = nil) {
        guard let urlString = urlString?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: urlString) else {
                  callBack?(RouterError.exception, "路由地址为空", nil)
                  return
              }
        
        guard let result = parse(url: url) else {
            callBack?(RouterError.exception, "数据解析异常", nil)
            return
        }
        
        router(result, callBack: callBack)
    }
    
    ///例：
    ///1、easyKits://aController?isNeedLogin=1
    ///2、easyKits://pushLogin
    private func parse(url: URL) -> RouterParseResult? {
        guard let host = url.host else {
                  return nil
              }
        let params = url.queryParameters
        return RouterParseResult(action: host,
                                 parameter: params,
                                 interceptorNode: interceptorNode(params))
    }
    
    private func interceptorNode(_ parameters: [String: String]? = nil) -> InterceptorNode? {
        guard let parameters = parameters else {
            return nil
        }

        var interceptor: [Interceptor.Type] = []

        if let isNeedLogin = parameters["isNeedLogin"].string,
           isNeedLogin == "1" {
            interceptor.append(LoginInterceptor.self)
        }
        
        return interceptor.interceptorNode
    }
}

extension URL {
    var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false), let queryItems = components.queryItems else { return nil }

        var items: [String: String] = [:]

        for queryItem in queryItems {
            items[queryItem.name] = queryItem.value
        }

        return items
    }
}

/// 登录拦截器
public class LoginInterceptor: Interceptor {
    public static func intercept(_ next: @escaping Next) {
        // 测试
        if false {
            next()
        } else {
            Mediator.bModule?.pushLogin({
                next()
            })
        }
    }
}
