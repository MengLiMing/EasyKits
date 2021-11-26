//
//  IGListKit+Ex.swift
//  EasyKits_Example
//
//  Created by Ming on 2021/11/26.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import RxSwift
import RxCocoa
import IGListKit

public extension Reactive where Base: ListAdapter {
    func performUpdate<T>(_ animation: Bool = false, completion: ((Bool) -> Void)? = nil) -> Binder<T> {
        return Binder(base) { target, _ in
            target.performUpdates(animated: animation) { value in
                completion?(value)
            }
        }
    }
}
