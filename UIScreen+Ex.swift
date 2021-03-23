//
//  UIScreen+Ex.swift
//  EasyKits
//
//  Created by 孟利明 on 2021/3/23.
//

import UIKit

public extension UIScreen {
    static var isFullScreen: Bool {
        return safeBottomMargin > 0
    }
    
    static var safeBottomMargin: CGFloat {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0
        }
        return 0
    }
    
    static var safeTopMargin: CGFloat {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0
        }
        return 0
    }
    
    static var statusBarHeight: CGFloat {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0
        }
        return UIApplication.shared.statusBarFrame.size.height
    }
    
    static let navBarHeight: CGFloat = 44
    
    static var navigationBarHeight: CGFloat {
        return statusBarHeight + navBarHeight
    }
    
    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.size.width
    }

    static var screenHeight: CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    static var bottomBarHeight: CGFloat {
        return 49 + safeBottomMargin
    }
}
