//
//  Array+Ex.swift
//  EasyKit
//
//  Created by 孟利明 on 2021/2/4.
//

import Foundation

public extension Array {
    func element(_ index: Int) -> Element? {
        guard index >= 0, self.count > index else {
            return nil
        }
        return self[index]
    }
}
