//
//  Observable+Ex.swift
//  Demo
//
//  Created by Ming on 2021/11/2.
//

import UIKit
import RxSwift
import RxCocoa

public extension ObservableType {
    /// 回顾历史元素
    /// - Returns: (old, new)
    func review() -> Observable<(Element?, Element)> {
        review(1).map { ($0.0.first, $0.1) }
    }
    
    
    /// 回顾历史元素
    /// - Parameter count: 历史元素个数
    /// - Returns: ([old]，new)
    func review(_ count: Int) -> Observable<([Element], Element)> {
        if count <= 0 { return map { ([], $0) } }
        return scan([]) {
            $0.suffix(count) + [$1]
        }.map {
            (Array($0[0..<$0.count-1]), $0[$0.count-1])
        }
    }
}

public extension ObservableConvertibleType {
    func resultDriver() -> Driver<Swift.Result<Element, Error>> {
        asObservable()
        
            .map { .success($0) }
            .asDriver(onErrorRecover: { .just(.failure($0)) } )
    }
    
    func mapViewController(_ config: @escaping (Element) -> UIViewController) -> Observable<UIViewController> {
        asObservable()
            .flatMapLatest { element -> Observable<UIViewController> in
                let viewController = config(element)
                return .create { observer in
                    observer.onNext(viewController)
                    observer.onCompleted()
                    return Disposables.create()
                }
            }
    }
}

public extension Swift.Result {
    var successValue: Success? {
        switch self {
        case .success(let value):
            return value
        default:
            return nil
        }
    }
    
    var failureValue: Failure? {
        switch self {
        case .failure(let failure):
            return failure
        default:
            return nil
        }
    }
}
