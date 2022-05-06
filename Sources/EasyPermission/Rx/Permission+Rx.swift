//
//  Permission+Rx.swift
//  BaseComponents
//
//  Created by Ming on 2021/11/10.
//

#if canImport(EasyPermission)
import EasyPermission
#endif

import RxSwift
import RxCocoa

public extension Accessor {
    /// 查询权限，没有权限不会申请
    var status: Signal<PermissionStatus> {
        return Observable.create { observer in
            status { status in
                observer.onNext(status)
                observer.onCompleted()
            }
            return Disposables.create()
        }
        .asSignal(onErrorSignalWith: .empty())
    }
    
    /// 直接申请权限
    var request: Signal<PermissionStatus> {
        return Observable.create { observer in
            request { status in
                observer.onNext(status)
                observer.onCompleted()
            }
            return Disposables.create()
        }
        .asSignal(onErrorSignalWith: .empty())
    }
    
    /// 访问权限，没有权限会自动申请
    var access: Signal<PermissionStatus> {
        return Observable.create { observer in
            access { status in
                observer.onNext(status)
                observer.onCompleted()
            }
            return Disposables.create()
        }
        .asSignal(onErrorSignalWith: .empty())
    }
}
