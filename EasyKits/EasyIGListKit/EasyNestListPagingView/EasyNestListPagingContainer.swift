//
//  EasyNestListPagingContainer.swift
//  EasyKits
//
//  Created by Ming on 2021/11/26.
//

import Foundation

public protocol EasyNestListPagingContainer: AnyObject {
    /// 横向滑动容器
    var horizontalScrollView: SyncScrollContainer { get }
    
    /// 内部滚动视图改变
    var innerScrollChangeHandler: ((SyncInnerScroll) -> Void)? { get set }
    
    /// 容器试图
    var nestContentView: UIView { get }
}

public extension EasyNestListPagingContainer where Self: UIViewController {
    var nestContentView: UIView {
        return self.view
    }
}

public extension EasyNestListPagingContainer where Self: UIView {
    var nestContentView: UIView {
        return self
    }
}
