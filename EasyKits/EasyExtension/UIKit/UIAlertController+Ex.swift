//
//  UIAlertController+Ex.swift
//  Demo
//
//  Created by Ming on 2021/11/2.
//

import UIKit
import RxSwift
import RxCocoa

public extension UIAlertController {
    struct Action<T> {
        public var title: String
        public var style: UIAlertAction.Style = .default
        public var value: T
        
        public init(title: String,
                    style: UIAlertAction.Style = .default,
                    value: T) {
            self.title = title
            self.style = style
            self.value = value
        }
    }
    
    @discardableResult
    static func show<T>(from: UIViewController?,
                        title: String?,
                        message: String?,
                        preferredStyle: UIAlertController.Style,
                        actions: [Action<T>],
                        handler: ((T) -> Void)?) -> UIAlertController? {
        guard let from = from else {
            return nil
        }
        let alertController = self.alertController(title: title, message: message, preferredStyle: preferredStyle, actions: actions, handler: handler)
        from.present(alertController, animated: true, completion: nil)
        
        return alertController
    }
    
    static func alertController<T>(title: String?,
                                   message: String?,
                                   preferredStyle: UIAlertController.Style,
                                   actions: [Action<T>],
                                   handler: ((T) -> Void)?) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        actions.forEach { action in
            let alertAction = UIAlertAction(title: action.title, style: action.style) { _ in
                handler?(action.value)
            }
            alertController.addAction(alertAction)
        }
        return alertController
    }
}

extension Reactive where Base: UIAlertController {
    static func show<T>(from: UIViewController?,
                 title: String?,
                 message: String?,
                 preferredStyle: UIAlertController.Style,
                 actions: [UIAlertController.Action<T>]) -> Observable<T> {
        return Observable.create { observer in
            let alertController = UIAlertController.show(from: from, title: title, message: message, preferredStyle: preferredStyle, actions: actions) { action in
                observer.onNext(action)
            }
            return Disposables.create {
                alertController?.dismiss(animated: true, completion: nil)
            }
        }
    }
}
