//
//  UIEdgeInsets+Ex.swift
//  EasyKits
//
//  Created by Ming on 2021/11/26.
//

import Foundation

public extension UIEdgeInsets {
    static func all(_ side: CGFloat) -> UIEdgeInsets {
        return .init(top: side, left: side, bottom: side, right: side)
    }

    init(hAxis: CGFloat = 0, vAxis: CGFloat = 0) {
        self.init(top: vAxis, left: hAxis, bottom: vAxis, right: hAxis)
    }

    static func left(_ value: CGFloat) -> UIEdgeInsets {
        return .init(top: 0, left: value, bottom: 0, right: 0)
    }

    static func right(_ value: CGFloat) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: value)
    }

    static func top(_ value: CGFloat) -> UIEdgeInsets {
        return .init(top: value, left: 0, bottom: 0, right: 0)
    }

    static func bottom(_ value: CGFloat) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: value, right: 0)
    }

    var hAxisValue: CGFloat {
        return left + right
    }

    var vAxisValue: CGFloat {
        return top + bottom
    }
}
