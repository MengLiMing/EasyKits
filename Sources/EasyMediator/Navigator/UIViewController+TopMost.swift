//
//  UIViewController+TopMost.swift
//  Mediator
//
//  Created by Ming on 2021/11/3.
//

import UIKit

public extension UIApplication {
    class var appWindows: [UIWindow] {
        if #available(iOS 13.0, *) {
            return UIApplication
                .shared
                .connectedScenes
                .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
        } else {
            return UIApplication.shared.windows
        }
    }
}

public extension UIViewController {
    class var topMost: UIViewController? {
        var rootViewController: UIViewController?
        
        for window in UIApplication.appWindows where window.isKeyWindow {
            if let windowRootViewController = window.rootViewController {
                rootViewController = windowRootViewController
                break
            }
        }
        
        return topMost(of: rootViewController)
    }
    
    
    class func topMost(of viewController: UIViewController?) -> UIViewController? {
        // presented view controller
        if let presentedViewController = viewController?.presentedViewController {
          return self.topMost(of: presentedViewController)
        }
        
        // UITabBarController
        if let tabBarController = viewController as? UITabBarController,
          let selectedViewController = tabBarController.selectedViewController {
          return self.topMost(of: selectedViewController)
        }

        // UINavigationController
        if let navigationController = viewController as? UINavigationController,
          let visibleViewController = navigationController.visibleViewController {
          return self.topMost(of: visibleViewController)
        }

        // UIPageController
        if let pageViewController = viewController as? UIPageViewController,
          pageViewController.viewControllers?.count == 1 {
          return self.topMost(of: pageViewController.viewControllers?.first)
        }

        // child view controller
        for subview in viewController?.view?.subviews ?? [] {
          if let childViewController = subview.next as? UIViewController {
            return self.topMost(of: childViewController)
          }
        }

        return viewController
    }
}
