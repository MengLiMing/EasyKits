//
//  UIScrollView+Rx.swift
//  EasyKit
//
//  Created by 孟利明 on 2021/2/4.
//

import UIKit
import RxSwift
import RxCocoa

public extension Reactive where Base: UIScrollView {
    var contentSize: Driver<CGSize> {
        return self.base.rx
            .observeWeakly(CGSize.self, #keyPath(UIScrollView.contentSize))
            .map { $0 ?? .zero }
            .asDriver(onErrorJustReturn: .zero)
    }
}
