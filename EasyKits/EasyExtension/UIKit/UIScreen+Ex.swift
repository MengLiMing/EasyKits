//
//  UIScreen+Ex.swift
//  EasyKits
//
//  Created by 孟利明 on 2021/3/23.
//

import UIKit

public extension UIScreen {
    /// 屏幕宽
    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    /// 屏幕高
    static var screenHeight: CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    
    /// 状态栏高度
    static var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *),
           let statusBarManager = UIApplication.statusBarManager {
            return statusBarManager.statusBarFrame.height
        }
        
        return UIApplication.shared.statusBarFrame.height
    }
    
    /// 是否隐藏了状态栏
    static var isStatusBarHidden: Bool {
        if #available(iOS 13.0, *),
           let starusBarManager = UIApplication.statusBarManager {
            return starusBarManager.isStatusBarHidden
        }
        
        return UIApplication.shared.isStatusBarHidden
    }
    
    static var topOffset: CGFloat {
        if #available(iOS 11, *),
           let window = UIApplication.appKeyWindow {
            return window.safeAreaInsets.top
        }
        
        return 0
    }
    
    static var bottomOffset: CGFloat {
        if #available(iOS 11, *),
           let window = UIApplication.appKeyWindow {
            return window.safeAreaInsets.bottom
        }
        return 0
    }
    
    /// 状态栏+导航栏
    static var navigationHeight: CGFloat {
        return statusBarHeight + navigationBarHeight
    }

    /// 导航栏高度
    static let navigationBarHeight: CGFloat = 44
    
    static var tabbarHeight: CGFloat {
        return bottomOffset + 49
    }
}
