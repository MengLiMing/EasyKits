//
//  UIResponder+Ex.swift
//  EasyKit
//
//  Created by 孟利明 on 2020/9/2.
//

import UIKit

public extension UIResponder {
    
    /// 单一层级事件响应
    /// - Parameter type: 点击事件代理Type Protocol.self
    /// - Returns: 响应事件的实例
    func delegate<T>(_ type: T.Type) -> T? {
        var result: T?
        var nextResponder: UIResponder? = self.next
        while nextResponder != nil {
            if let delegate = nextResponder as? T {
                result = delegate
                break
            }
            nextResponder = nextResponder?.next
        }
        return result
    }
    
    /// 多层级响应同一事件
    /// - Parameters:
    ///   - type: type: 点击事件代理Type Protocol.self
    ///   - handler: 响应
    func delegate<T>(_ type: T.Type, handler: @escaping (T) -> Void) {
        var nextResponder: UIResponder? = self.next
        while nextResponder != nil {
            if let delegate = nextResponder as? T {
                handler(delegate)
            }
            nextResponder = nextResponder?.next
        }
    }
}


protocol CellHandler {
    func cellAction1()
    
    func cellAction2()
}

class Cell: UITableViewCell {
    func action() {
        self.delegate(CellHandler.self)?.cellAction1()
    }
}

class VC: UIViewController {
    
}
extension VC: CellHandler {
    func cellAction1() {
        print("cell的点击事件")
    }
    
    func cellAction2() {
        print("cell的点击事件")
    }
}
