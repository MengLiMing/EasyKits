//
//  RouterTarget.swift
//  EasyKits
//
//  Created by Ming on 2022/2/17.
//

import Foundation

open class RouterTarget: NSObject {
    func perform(action: String, params: [String : Any]?) {
        // 先调用带参
        let methodWithArgsSelector = NSSelectorFromString(action+":")
        if self.responds(to: methodWithArgsSelector) {
            self.perform(methodWithArgsSelector, with: params)
            return
        }
        
        // 不带参
        let methodSelector = NSSelectorFromString(action)
        if self.responds(to: methodSelector) {
            self.perform(methodSelector)
            return
        }
        
        params?.routerCallBack?(RouterError.noAction, nil, nil)
    }
}
