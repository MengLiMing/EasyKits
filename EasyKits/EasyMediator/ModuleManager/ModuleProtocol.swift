//
//  ModuleProtocol.swift
//  EasyKits
//
//  Created by Ming on 2022/2/17.
//

import Foundation

public protocol ModuleProtocol {
    /// 模块ID 非必须
    func moduleID() -> String
    /// 模块级别
    func moduleLevel() -> Int
    /// 销毁模块
    func destoryModule()
}

public extension ModuleProtocol where Self: NSObject {
    func destoryModule() {
        ModuleManager.shared.removeModule(self.moduleID())
    }
    
    func moduleID() -> String {
        return NSStringFromClass(Self.self)
    }
    
    func moduleLevel() -> Int {
        return 100
    }
}
