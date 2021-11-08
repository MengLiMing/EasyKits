//
//  Optional+Ex.swift
//  Demo
//
//  Created by Ming on 2021/11/2.
//

import Foundation

private let formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.usesGroupingSeparator = false
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 16
    return formatter
}()

public extension Optional {
    var isNull: Bool {
        switch self {
        case .none:
            return true
        case .some(let wrapped):
            return wrapped is NSNull
        }
    }
    
    var string: String? {
        guard isNull == false,
                let wrapped = self else {
            return nil
        }
        switch wrapped {
        case let string as String:
            return string
        case let num as NSNumber:
            if NSStringFromClass(type(of: num)) == "__NSCFBoolean" {
                if num.boolValue {
                    return "true"
                } else {
                    return "false"
                }
            }
            return formatter.string(from: num)
        case _ as NSNull:
            return nil
        default:
            return "\(wrapped)"
        }
    }
}

public extension Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        if self.isNull {
            return true
        }
        switch self {
        case .none:
            return true
        case .some(let wrapped):
            return wrapped.isEmpty
        }
    }
}

