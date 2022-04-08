//
//  EasyListHeadFootType.swift
//  EasyKit
//
//  Created by 孟利明 on 2020/7/2.
//

import UIKit

public protocol EasyListHeadFootTypeLimit {
    func viewClass() -> EasyListHeaderFooterView.Type
    func viewID() -> String
}

public extension EasyListHeadFootTypeLimit {
    func viewID() -> String {
        return NSStringFromClass(self.viewClass())
    }
}

public struct EasyListHeadFootLimit<E: EasyListHeaderFooterView>: EasyListHeadFootTypeLimit {
    public func viewClass() -> EasyListHeaderFooterView.Type {
        return E.self
    }
}
