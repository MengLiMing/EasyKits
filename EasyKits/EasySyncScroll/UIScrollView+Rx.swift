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
    var kvo_contentSize: Observable<CGSize> {
        base.rx
            .observeWeakly(CGSize.self, #keyPath(UIScrollView.contentSize))
            .compactMap { $0 }
    }
    
    var kvo_contentOffset: Observable<CGPoint> {
        base.rx
            .observeWeakly(CGPoint.self, #keyPath(UIScrollView.contentOffset))
            .compactMap { $0 }
    }
    
    var kvo_delegate: Observable<UIScrollViewDelegate?> {
        base.rx
            .observeWeakly(UIScrollViewDelegate.self, #keyPath(UIScrollView.delegate))
    }
}
