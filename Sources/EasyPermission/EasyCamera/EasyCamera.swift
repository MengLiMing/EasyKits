//
//  EasyCamera.swift
//  BaseComponents
//
//  Created by Ming on 2021/11/10.
//

#if canImport(EasyPermission)
import EasyPermission
#endif

#if PERMISSION_EASYCAMERA
import AVFoundation

/**
 <key>NSCameraUsageDescription</key>
 <string>我们需要您的相机权限，【填写用途】</string>
 */

public extension Permission {
    static let camera: Accessor = EasyCamera()
}

public struct EasyCamera {}

extension EasyCamera: Accessor {
    public func status(_ callback: @escaping PermissionStatus.Callback) {
        callback(AVCaptureDevice.authorizationStatus(for: .video).status)
    }
    
    public func request(_ callback: @escaping PermissionStatus.Callback) {
        AVCaptureDevice.requestAccess(for: .video) { _ in
            DispatchQueue.main.async {
                self.status { callback($0) }
            }
        }
    }
}

extension AVAuthorizationStatus {
    var status: PermissionStatus {
        switch self {
        case .notDetermined: return .notDetermined
        case .restricted: return .denied
        case .denied: return .denied
        case .authorized: return .authorized
        @unknown default: return .denied
        }
    }
}
#endif
