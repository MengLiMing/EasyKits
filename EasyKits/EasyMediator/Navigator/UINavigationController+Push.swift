//
//  UINavigationController+Push.swift
//  Mediator
//
//  Created by Ming on 2022/2/8.
//

import UIKit

public extension UINavigationController {
    
    /// 检查当前viewController类出现的最大次数，如果超过maxCount，则移除之前的viewController
    /// - Parameters:
    ///   - viewController: 类
    ///   - maxCount: 最大个数
    func filter<T>(viewControllerWithClass classType: T.Type, maxCount: Int) where T: UIViewController {
        guard viewControllers.count > maxCount else {
            return
        }
        var resultViewControllers: [UIViewController] = []
        var currentDetailCount = 0
        for viewController in viewControllers.reversed() {
            if viewController.isKind(of: classType) {
                currentDetailCount += 1
                if currentDetailCount <= maxCount {
                    resultViewControllers.append(viewController)
                }
            } else {
                resultViewControllers.append(viewController)
            }
        }
        if resultViewControllers.count >= 1,
           resultViewControllers.count < viewControllers.count {
        }
        self.viewControllers = Array(resultViewControllers.reversed())
    }
    
    
    /// PUSH
    /// - Parameters:
    ///   - viewController: 页面
    ///   - exitNumber: 退出之前的几个页面
    ///   - animated: 是否有动画
    func push(viewController: UIViewController, exitNumber: Int = 0, animated: Bool) {
        var viewControllers: [UIViewController] = self.viewControllers
        let number = min(max(viewControllers.count - 1, 0), exitNumber)
        let rightIndex = viewControllers.count - number
        viewControllers = Array(viewControllers[0..<rightIndex])
        if animated {
            viewControllers.append(viewController)
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                self.viewControllers = viewControllers
            }
            self.pushViewController(viewController, animated: true)
            CATransaction.commit()
        } else {
            self.viewControllers = viewControllers
            self.pushViewController(viewController, animated: false)
        }
    }
    
    /// PUSH
    /// - Parameters:
    ///   - viewController: 页面
    ///   - exitToVC: 退出到当前控制器
    ///   - animated: 是否有动画
    func push(viewController: UIViewController,
              exitToVC: UIViewController,
              animated: Bool) {
        push(viewController: viewController, exitToTarget: {
            $0 == exitToVC
        }, animated: animated)
    }
    
    /// PUSH
    /// - Parameters:
    ///   - viewController: 页面
    ///   - exitToClass: 退出到当前类的控制器
    ///   - animated: 是否有动画
    func push(viewController: UIViewController,
              exitToClass: UIViewController.Type,
              animated: Bool) {
        push(viewController: viewController, exitToTarget: {
            $0.isKind(of: exitToClass)
        }, animated: animated)
    }
    
    /// PUSH
    /// - Parameters:
    ///   - viewController: 页面
    ///   - exitToTarget: 判断退出到那个页面
    ///   - animated: 是否有动画
    func push(viewController: UIViewController,
              exitToTarget: (UIViewController) -> Bool,
              animated: Bool) {
        let index = self.viewControllers.reversed().firstIndex(where: exitToTarget) ?? 0
        push(viewController: viewController, exitNumber: index, animated: animated)
    }
}
