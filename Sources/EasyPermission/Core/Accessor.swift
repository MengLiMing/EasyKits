//
//  Accessor.swift
//  BaseComponents
//
//  Created by Ming on 2021/11/10.
//

import Foundation

public protocol Accessor {
    /// 查询权限, 没有权限不会申请
    func status(_ callback: @escaping PermissionStatus.Callback)
    
    /// 直接申请权限
    func request(_ callback: @escaping PermissionStatus.Callback)
}

extension Accessor {
    /// 访问, 没有权限会申请权限
    public func access(_ callback: @escaping PermissionStatus.Callback) {
        status { status in
            if status.isNotDetermined {
                request(callback)
            } else {
                callback(status)
            }
        }
    }
}
