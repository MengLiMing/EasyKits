//
//  EasyBluetooth.swift
//  EasyKits
//
//  Created by 孟利明 on 2022/10/20.
//

#if canImport(EasyPermission)
import EasyPermission
#endif


#if PERMISSION_EASYBLUETOOTH
import CoreBluetooth

/// iOS13之前
/**
 <key>NSBluetoothPeripheralUsageDescription</key>
 <string>我们需要您的蓝牙权限，【填写用途】</string>
 */

/// iOS13之后
/**
 <key>NSBluetoothAlwaysUsageDescription</key>
 <string>我们需要您的蓝牙权限，【填写用途】</string>
 */

public extension Permission {
    static let bluetooth: Accessor = EasyBluetooth()
}

public struct EasyBluetooth { }

extension EasyBluetooth: Accessor {
    public func request(_ callback: @escaping PermissionStatus.Callback) {
        EasyBluetoothHandler.shared = EasyBluetoothHandler()
        EasyBluetoothHandler.shared?.requestPermisson {
            DispatchQueue.main.async {
                self.status { callback($0) }
                EasyBluetoothHandler.shared = nil
            }
        }
    }
    
    public func status(_ callback: @escaping PermissionStatus.Callback) {
        if #available(iOS 13.1, *) {
            callback(CBCentralManager.authorization.status)
        } else if #available(iOS 13.0, *) {
            callback(CBCentralManager().authorization.status)
        } else {
            callback(CBPeripheralManager.authorizationStatus().status)
        }
    }
}


class EasyBluetoothHandler: NSObject, CBCentralManagerDelegate {
    static var shared: EasyBluetoothHandler?
    
    var manager: CBCentralManager?
    
    var completion: (() -> Void)?
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        completion?()
    }
    
    func requestPermisson(completion: @escaping () -> Void) {
        if manager == nil {
            self.completion = completion
            manager = CBCentralManager(delegate: self, queue: nil)
        } else {
            completion()
        }
    }
}

@available(iOS 13.0, *)
extension CBManagerAuthorization {
    var status: PermissionStatus {
        switch self {
        case .notDetermined:
            return .notDetermined
        case .restricted:
            return .denied
        case .denied:
            return .denied
        case .allowedAlways:
            return .authorized
        @unknown default:
            return .denied
        }
    }
}

extension CBPeripheralManagerAuthorizationStatus {
    var status: PermissionStatus {
        switch self {
        case .notDetermined:
            return .notDetermined
        case .restricted:
            return .denied
        case .denied:
            return .denied
        case .authorized:
            return .authorized
        @unknown default:
            return .denied
        }
    }
}

#endif
