//
//  CGFloat+Ex.swift
//  EasyKit
//
//  Created by 孟利明 on 2020/6/28.
//

public extension CGFloat {
    var fit: CGFloat {
        let value = self / 375.0 * .screenWidth
        return Swift.abs(CGFloat(Int(value * 100)) / 100)
    }
}

public extension Double {
    var fit: CGFloat {
        return CGFloat(self).fit
    }
}

public extension Int {
    var fit: CGFloat {
        return CGFloat(self).fit
    }
    var float:CGFloat {
        return CGFloat(self)
    }
}

public extension CGFloat {
    /// 屏幕宽
    static let screenWidth = UIScreen.main.bounds.width
    /// 屏幕高
    static let screenHeight = UIScreen.main.bounds.height
    /// 底部安全区域高度
    static let safeBottomMargin: CGFloat = {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0
        }
        return 0
    }()
    
    /// 状态栏高度
    static let statusBarHeight: CGFloat = {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0
        }
        return UIApplication.shared.statusBarFrame.size.height
    }()
    /// 导航栏高度
    static let navBarHeight: CGFloat = 44
    
    /// 导航+状态栏高度
    static let navBarAndStatusBarHeight = statusBarHeight + navBarHeight

    /// 底部tabbar高度
    static let tabbarHeight: CGFloat = 49 + safeBottomMargin
}
