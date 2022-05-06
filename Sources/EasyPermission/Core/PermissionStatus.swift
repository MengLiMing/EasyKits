//
//  PermissionStatus.swift
//  BaseComponents
//
//  Created by Ming on 2021/11/10.
//

import Foundation

public enum PermissionStatus {
    public typealias Callback = (PermissionStatus) -> Void

    /// 已授权
    case authorized
    /// 已拒绝
    case denied
    /// 未申请
    case notDetermined
    /// 不支持
    case notSupported
}


public extension PermissionStatus {
    var isAuthorized: Bool {
        self == .authorized
    }
    
    var isDenied: Bool {
        self == .denied
    }
    
    var isNotDetermined: Bool {
        self == .notDetermined
    }
}
