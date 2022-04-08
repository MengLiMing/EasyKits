//
//  Navigator.swift
//  BaseComponents
//
//  Created by Ming on 2021/11/17.
//

import UIKit
import RxSwift

#if canImport(EasyExtension)
    import EasyExtension
#endif

public class Navigator { }


public extension Navigator {
    static var navigationController: UINavigationController? {
        UIViewController.topMost?.navigationController
    }
    
    static func push(_ viewController: UIViewController, animation: Bool = true) {
        navigationController?.pushViewController(viewController, animated: animation)
    }
    
    static func present(_ viewController: UIViewController, animation: Bool = true, completion: (() -> Void)? = nil) {
        UIViewController.topMost?.present(viewController, animated: animation, completion: completion)
    }
    
    static func dismiss(animation: Bool = true, completion: (() -> Void)? = nil) {
        UIViewController.topMost?.dismiss(animated: animation, completion: completion)
    }
    
    static func popToRoot(animated: Bool = true) -> [UIViewController]? {
        return navigationController?.popToRootViewController(animated: animated)
    }
    
    static func pop(to viewController: UIViewController, animated: Bool = true) -> [UIViewController]? {
        navigationController?.popToViewController(viewController, animated: animated)
    }
    
    static func pop(to vcClass: UIViewController.Type) -> [UIViewController]? {
        guard let nav = navigationController else {
            return nil
        }
        for vc in nav.viewControllers.reversed() {
            if vc.isKind(of: vcClass) {
                return pop(to: vc)
            }
        }
        
        return nil
    }
    
    static func push(viewController: UIViewController,
                     exitNumber: Int = 0,
                     animated: Bool = true) {
        navigationController?.push(viewController: viewController,
                                   exitNumber: exitNumber,
                                   animated: animated)
    }
    
    static func push(viewController: UIViewController,
                     exitToVC: UIViewController,
                     animated: Bool) {
        navigationController?.push(viewController: viewController, exitToVC: exitToVC, animated: animated)
    }
    
    static func push(viewController: UIViewController,
                     exitToClass: UIViewController.Type,
                     animated: Bool) {
        navigationController?.push(viewController: viewController, exitToClass: exitToClass, animated: animated)
    }
    
    static func push(viewController: UIViewController,
                     exitToTarget: (UIViewController) -> Bool,
                     animated: Bool) {
        navigationController?.push(viewController: viewController, exitToTarget: exitToTarget, animated: animated)
    }
    
    /// 返回上一级
    static func pop(animated: Bool = true) -> UIViewController? {
        return UIViewController.topMost?.navigationController?.popViewController(animated: animated)
    }
    
    /// 跳转到根视图，并切换tabbar下标到tabIndex
    static func popToRoot(atTabIndex tabIndex: Int) {
        guard let tabbarController = UIApplication.appKeyWindow?.rootViewController as? UITabBarController,
              let tabCount = tabbarController.viewControllers?.count,
              tabCount > 0,
        let navController = tabbarController.selectedViewController as? UINavigationController else {
            return
        }
        
        if tabIndex >= 0, tabIndex < tabCount {
            if tabbarController.selectedIndex == tabIndex {
                navController.popToRootViewController(animated: true)
            } else {
                navController.popToRootViewController(animated: false)
                tabbarController.selectedIndex = tabIndex
            }
        } else {
            navController.popToRootViewController(animated: true)
        }
    }
}


extension Navigator: ReactiveCompatible { }
public extension Reactive where Base: Navigator {
    static func push(animation: Bool = true) -> TypeBinder<UIViewController> {
        return TypeBinder(Base.self) { target, value in
            target.push(value, animation: animation)
        }
    }
    
    static func present(animation: Bool = true,
                        completion: (() -> Void)? = nil) -> TypeBinder<UIViewController> {
        return TypeBinder(Base.self) { target, value in
            target.present(value, animation: animation, completion: completion)
        }
    }
    
    static func dismiss(animation: Bool = true,
                        completion: (() -> Void)? = nil) -> TypeBinder<Void> {
        return TypeBinder(Base.self) { target, value in
            target.dismiss(animation: animation, completion: completion)
        }
    }
}
