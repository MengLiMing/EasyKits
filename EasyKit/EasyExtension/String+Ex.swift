//
//  String+Ex.swift
//  EasyKit
//
//  Created by 孟利明 on 2021/2/4.
//

import Foundation

public extension String {
    func substring(to index: Int) -> String {
        return substring(from: 0, to: index)
    }
    
    func substring(with range: NSRange) -> String {
        return substring(from: range.location, to: range.location + range.length)
    }
    
    func substring(from index: Int) -> String {
        return substring(from: index, to: self.count)
    }
    
    func substring(from fromIndex: Int, length: Int) -> String {
        return self.substring(from: fromIndex, to: fromIndex + length)
    }
    
    func substring(from fromIndex: Int, to toIndex: Int) -> String {
        let from = min(max(0, fromIndex), self.count)
        let to = min(max(0, toIndex), self.count)
        if from > to {
            return self
        }
        if from == to {
            return ""
        }
        let left = self.index(startIndex, offsetBy: from)
        let right = self.index(startIndex, offsetBy: to)
        return String(self[left..<right])
    }
}
