//
//  RxReview.swift
//  EasyKits
//
//  Created by Ming on 2021/4/10.
//

import RxSwift

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
    
    /// 记一次scan使用，RxSwift有相应的操作符 enumerated
    @available(*, unavailable)
    func withIndex() -> Observable<(Int,Element)> {
        scan(nil) {
            (($0?.0 ?? -1) + 1, $1)
        }.compactMap { $0 }
    }
}
