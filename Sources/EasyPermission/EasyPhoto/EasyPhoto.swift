//
//  EasyPhoto.swift
//  BaseComponents
//
//  Created by Ming on 2021/11/10.
//

#if canImport(EasyPermission)
import EasyPermission
#endif

#if PERMISSION_EASYPHOTO
import Photos

/**
 <key>NSPhotoLibraryAddUsageDescription</key>
 <string>我们需要您的照片库存储权限，【填写用途】</string>
 <key>NSPhotoLibraryUsageDescription</key>
 <string>我们需要您的照片库权限，【填写用途】</string>
 */

public extension Permission {
    static let photo: Accessor = EasyPhoto()
}

public struct EasyPhoto {}

extension EasyPhoto: Accessor {
    public func status(_ callback: @escaping PermissionStatus.Callback) {
        callback(PHPhotoLibrary.authorizationStatus().status)
    }
    
    public func request(_ callback: @escaping PermissionStatus.Callback) {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                callback(status.status)
            }
        }
    }
}

extension PHAuthorizationStatus {
    var status: PermissionStatus {
        switch self {
        case .authorized: return .authorized
        case .denied: return .denied
        case .notDetermined: return .notDetermined
        case .restricted: return .denied
        case .limited: return .authorized
        @unknown default: return .denied
        }
    }
}
#endif
