//
//  WeakWrapper.swift
//  EasyKits
//
//  Created by Ming on 2021/8/23.
//

import Foundation

public class WeakWrapper<T: AnyObject> {
    public private(set) weak var obj: T?
    
    public init(_ obj: T) {
        self.obj = obj
    }
}
