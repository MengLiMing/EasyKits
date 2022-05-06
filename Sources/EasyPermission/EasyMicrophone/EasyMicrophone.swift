//
//  EasyMicrophone.swift
//  BaseComponents
//
//  Created by Ming on 2021/11/12.
//

#if canImport(EasyPermission)
import EasyPermission
#endif

#if PERMISSION_EASYMICROPHONE
import AVFoundation

/**
 <key>NSMicrophoneUsageDescription</key>
 <string>我们需要您的麦克风权限，【填写用途】</string>
 */

public extension Permission {
    static let microphone: Accessor = EasyMicrophone()
}

public struct EasyMicrophone { }

extension EasyMicrophone: Accessor {
    public func status(_ callback: @escaping PermissionStatus.Callback) {
        callback(AVAudioSession.sharedInstance().recordPermission.status)
    }
    
    public func request(_ callback: @escaping PermissionStatus.Callback) {
        AVAudioSession.sharedInstance().requestRecordPermission { _ in
            DispatchQueue.main.async {
                self.status { callback($0) }
            }
        }
    }
}

extension AVAudioSession.RecordPermission {
    var status: PermissionStatus {
        switch self {
        case .granted: return .authorized
        case .denied: return .denied
        case .undetermined: return .notDetermined
        @unknown default: return .denied
        }
    }
}
#endif
