//
//  SyncScrollContainer.swift
//  NiceTuanUIComponents
//
//  Created by Ming on 2021/8/23.
//

import Foundation

/// 横向滑动容器
public protocol SyncScrollContainer: AnyObject {
    /// 容器内所有的items需要滚动到顶部滚动
    func resetContainerItems(_ resetItem: (SyncInnerScroll) -> ())
}
