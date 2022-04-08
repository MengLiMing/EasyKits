//
//  Mediator.swift
//  Mediator
//
//  Created by Ming on 2021/11/3.
//

import Foundation

public final class Mediator {
    public static let shared = Mediator()
    
    private init() { }
    
    private var providers: [String: Any] = [:]
}

public extension Mediator {
    func register<T>(_ provider: T, protocolType: T.Type) {
        providers[key(protocolType)] = provider
    }
    
    func provider<T>(_ protocolType: T.Type) -> T? {
        providers[key(protocolType)] as? T
    }
    
    func remove<T>(protocolType: T.Type) {
        providers.removeValue(forKey: key(protocolType))
    }
    
    fileprivate func key<T>(_ prototolType: T.Type) -> String {
        return "\(type(of: prototolType))"
    }
}

// Example:

///// 用户模块需要提供的接口
///// 接口定义在Basics下
//protocol UserInterface {
//    func login()
//    func logout()
//}
//
///// 对应模块提供
//class UserInterfaceProvider: UserInterface {
//    func login() {
//        print("登录")
//    }
//
//    func logout() {
//        print("退出")
//    }
//}
///// 对应模块应用启动时注册
//Mediator.default.register(UserInterfaceProvider(), protocolType: UserInterface.self)
//
//
///// 使用
//Mediator.default.provider(UserInterface.self)?.login()
//Mediator.default.provider(UserInterface.self)?.logout()
