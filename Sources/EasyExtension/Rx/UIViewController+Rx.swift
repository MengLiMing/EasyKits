//
//  UIViewController+Rx.swift
//  Demo
//
//  Created by Ming on 2021/11/2.
//

import UIKit
import RxSwift
import RxCocoa

public extension Reactive where Base: UIViewController {
    func push(animation: Bool = true) -> Binder<UIViewController> {
        return Binder(base) { target, value in
            target.navigationController?.pushViewController(value, animated: animation)
        }
    }
    
    func present(animation: Bool = true, completion: (() -> Void)? = nil) -> Binder<UIViewController> {
        return Binder(base) { target, value in
            target.present(value, animated: animation) {
                completion?()
            }
        }
    }
    
    func dismiss(animation: Bool = true, completion: (() -> Void)? = nil) -> Binder<Void> {
        return Binder(base) { target, _ in
            target.dismiss(animated: animation) {
                completion?()
            }
        }
    }
    
    func pop(animation: Bool = true) -> Binder<Void> {
        return Binder(base) { target, _ in
            target.navigationController?.popViewController(animated: animation)
        }
    }
}
