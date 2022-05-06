//
//  EasyLocation.swift
//  BaseComponents
//
//  Created by Ming on 2021/11/10.
//

#if canImport(EasyPermission)
import EasyPermission
#endif

#if PERMISSION_EASYLOCATION
import Foundation
import CoreLocation

/**
 <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
 <string>我们需要您的位置权限，【填写用途】</string>
 <key>NSLocationAlwaysUsageDescription</key>
 <string>我们需要您的位置权限，【填写用途】</string>
 <key>NSLocationWhenInUseUsageDescription</key>
 <string>我们需要您的位置权限，【填写用途】</string>
 */

public extension Permission {
    static let locationAlways: Accessor = EasyLocation(usage: .always)
    static let locationWhenInUse: Accessor = EasyLocation(usage: .whenInUse)
}

public struct EasyLocation {
    public enum Usage {
        case always
        case whenInUse
    }
    
    public let usage: Usage
    
    public init(usage: Usage) {
        self.usage = usage
    }
}

extension EasyLocation: Accessor {
    public func status(_ callback: @escaping PermissionStatus.Callback) {
        callback(CLLocationManager.status.status(usage))
    }
    
    public func request(_ callback: @escaping PermissionStatus.Callback) {
        EasyLocationHandler.shared = EasyLocationHandler()
        EasyLocationHandler.shared?.requestPermisson(usage, completion: { status in
            DispatchQueue.main.async {
                callback(status.status(self.usage))
                EasyLocationHandler.shared = nil
            }
        })
    }
}


class EasyLocationHandler: NSObject, CLLocationManagerDelegate {
    static var shared: EasyLocationHandler?
    
    lazy var locationManager = CLLocationManager()
    
    var completionHandler: (CLAuthorizationStatus) -> Void = { _ in }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .notDetermined {
            return
        }
        completionHandler(status)
    }
    
    func requestPermisson(_ usage: EasyLocation.Usage, completion: @escaping (CLAuthorizationStatus) -> Void) {
        self.completionHandler = completion
                
        switch usage {
        case .whenInUse:
            requestWhenInUse()
        case .always:
            requestAlways()
        }
    }
    
    private func requestWhenInUse() {
        let status = CLLocationManager.status

        switch status {
        case .notDetermined:
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
        default:
            completionHandler(status)
        }
    }
    
    private func requestAlways() {
        let status = CLLocationManager.status

        switch status {
        case .notDetermined:
            locationManager.delegate = self
            locationManager.requestAlwaysAuthorization()
        case .authorizedWhenInUse:
            locationManager.delegate = self
            locationManager.requestAlwaysAuthorization()
        default:
            completionHandler(status)
        }
    }
}

extension CLLocationManager {
    static var status: CLAuthorizationStatus {
        if #available(iOS 14.0, *) {
            return CLLocationManager().authorizationStatus
        } else {
            return CLLocationManager.authorizationStatus()
        }
    }
}


extension CLAuthorizationStatus {
    func status(_ usage: EasyLocation.Usage) -> PermissionStatus {
        switch self {
        case .authorized: return .authorized
        case .denied: return .denied
        case .notDetermined: return .notDetermined
        case .restricted: return .denied
        case .authorizedAlways: return .authorized
        case .authorizedWhenInUse:
            switch usage {
            case .always:
                return .denied
            case .whenInUse:
                return .authorized
            }
        @unknown default: return .denied
        }
    }
}
#endif
