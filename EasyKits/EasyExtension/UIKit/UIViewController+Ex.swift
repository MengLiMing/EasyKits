//
//  UIViewController+Ex.swift
//  Demo
//
//  Created by Ming on 2021/11/2.
//

import Foundation
import UIKit

public extension UIViewController {
    // iOS scrollview 及其子类带有导航栏时自动调整内边距问题
    func adjustScrollContentInset(_ scrollView: UIScrollView?) {
        if #available(iOS 11.0, *) {
            scrollView?.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }
}
