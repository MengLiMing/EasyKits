//
//  UIScrollView+Refresh.swift
//  EasyKits_Example
//
//  Created by Ming on 2021/11/26.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import MJRefresh

private struct AssociatedKeys {
    static var scrollView_refresh_header_observable: UInt8 = 0
    static var scrollView_refresh_footer_observable: UInt8 = 0
}

/// 结束刷新的状态
public enum EndedRefreshState {
    case normal
    
    case noMore
}

public extension Reactive where Base: UIScrollView {
    
    var headerRefresh: ControlEvent<Void> {
        let observable = lazyAssociatedObservable(forKey: &AssociatedKeys.scrollView_refresh_header_observable) {
            Observable<Void>.create { [weak base] observer in
                base?.mj_header = MJRefreshNormalHeader(refreshingBlock: {
                    observer.onNext(())
                })
                return Disposables.create()
            }
            .take(until: base.rx.deallocated)
            .share()
        }
        
        return .init(events: observable)
    }
    
    var footerRefresh: ControlEvent<Void> {
        let observable = lazyAssociatedObservable(forKey: &AssociatedKeys.scrollView_refresh_footer_observable) {
            Observable<Void>
                .create({ [weak base] observer in
                    base?.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
                        observer.onNext(())
                    })
                    return Disposables.create()
                })
                .take(until: base.rx.deallocated)
                .share()
        }
        return .init(events: observable)
    }
    
    var endRefresh: Binder<EndedRefreshState> {
        return Binder(base) { target, state in
            target.mj_header?.endRefreshing()
            guard let mjFooter = target.mj_footer else {
                return
            }
            switch state {
            case .normal:
                if mjFooter.isRefreshing {
                    mjFooter.endRefreshing()
                } else {
                    mjFooter.resetNoMoreData()
                }
            case .noMore:
                mjFooter.endRefreshingWithNoMoreData()
            }
        }
    }
    
    private func lazyAssociatedObservable<T>(forKey key: UnsafeRawPointer, create: () -> Observable<T>) -> Observable<T> {
        if let object = objc_getAssociatedObject(base, key) as? Observable<T> {
            return object
        }
        
        let object = create()
        
        objc_setAssociatedObject(self, key, object, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        return object
    }
    
}
