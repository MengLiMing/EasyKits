//
//  UIApplication+Ex.swift
//  Demo
//
//  Created by Ming on 2021/11/2.
//

import UIKit

public extension UIApplication {
    /// 获取keywindow
    class var window: UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication
                .shared
                .connectedScenes
                .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                .first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
    
    @available(iOS 13.0, *)
    class var statusBarManager: UIStatusBarManager? {
        return UIApplication.shared.delegate?.window??.windowScene?.statusBarManager
    }
    
    class func `open`(_ urlString: String?, completion: ((Bool) -> Void)? = nil) {
        guard let urlString = urlString else {
            completion?(false)
            return
        }
        
        UIApplication.open(URL(string: urlString), completion: completion)
    }
    
    class func`open`(_ url: URL?, completion: ((Bool) -> Void)? = nil) {
        guard let url = url, UIApplication.shared.canOpenURL(url) else {
            completion?(false)
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }
    
    class func openSetting(completion: ((Bool) -> Void)? = nil) {
        UIApplication.open(UIApplication.openSettingsURLString, completion: completion)
    }
    
    class func openTel(tel: String?, completion: ((Bool) -> Void)? = nil) {
        guard let tel = tel, tel.isEmpty == false else {
            completion?(false)
            return
        }
        
        UIApplication.open("tel:" + tel, completion: completion)
    }
}
