//
//  EasyListCellType.swift
//  EasyKit
//
//  Created by 孟利明 on 2020/6/28.
//

import UIKit

public protocol EasyListCellTypeLimit {
    func cellClass() -> EasyListViewCell.Type
    
    func cellID() -> String
}

public extension EasyListCellTypeLimit {
    func cellID() -> String {
        return NSStringFromClass(self.cellClass())
    }
}

/// 扩展方便使用
public struct EasyListCellLimit<T: EasyListViewCell>: EasyListCellTypeLimit {
    public func cellClass() -> EasyListViewCell.Type {
        return T.self
    }
}
