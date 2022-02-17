//
//  Router+Parseable.swift
//  EasyKits
//
//  Created by Ming on 2022/2/17.
//

import Foundation


/// 调用会以： @objc func action(parameters: [String: Any])
public struct RouterParseResult {
    public let action: String
    public let parameter: [String: Any]?
    
    public let interceptorNode: InterceptorNode?

    public init(action: String,
         parameter: [String: Any]? = nil,
         interceptorNode: InterceptorNode? = nil
    ) {
        self.action = action
        self.parameter = parameter
        self.interceptorNode = interceptorNode
    }
}


public extension Router {
    func router(_ routerParse: RouterParseResult,
                callBack: CallBack? = nil) {
        performTarget(action: routerParse.action,
                      parameter: routerParse.parameter,
                      interceptorNode: routerParse.interceptorNode,
                      callBack: callBack)
    }
}
