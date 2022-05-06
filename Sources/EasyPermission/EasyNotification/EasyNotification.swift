//
//  EasyNotification.swift
//  BaseComponents
//
//  Created by Ming on 2021/11/10.
//
#if canImport(EasyPermission)
import EasyPermission
#endif

#if PERMISSION_EASYNOTIFICATION
import Foundation
import UserNotifications

public extension Permission {
    static let notification: Accessor = EasyNotification()
}

public struct EasyNotification { }

extension EasyNotification: Accessor {
    public func status(_ callback: @escaping PermissionStatus.Callback) {
        DispatchQueue.global().async {
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                DispatchQueue.main.async {
                    callback(settings.authorizationStatus.status)
                }
            }
        }
    }
    
    public func request(_ callback: @escaping PermissionStatus.Callback) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { _, _ in
            status { status in
                DispatchQueue.main.async {
                    callback(status)
                }
            }
        }
    }
}

extension UNAuthorizationStatus {
    var status: PermissionStatus {
        switch self {
        case .notDetermined: return .notDetermined
        case .denied: return .denied
        case .authorized: return .authorized
        case .provisional: return .authorized
        case .ephemeral: return .authorized
        @unknown default: return .denied
        }
    }
}
#endif
