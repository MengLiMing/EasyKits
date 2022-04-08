//
//  Sequence+Ex.swift
//  Demo
//
//  Created by Ming on 2021/11/2.
//

import Foundation

public extension Sequence {
    func map<T>(_ keyPath: KeyPath<Element, T>) -> [T] {
        return map { $0[keyPath: keyPath] }
    }
    
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>, isAsc: Bool = true) -> [Element] {
        return sorted { lhs, rhs in
            if isAsc {
                return lhs[keyPath: keyPath] <= rhs[keyPath: keyPath]
            } else {
                return lhs[keyPath: keyPath] > rhs[keyPath: keyPath]
            }
        }
    }
}
