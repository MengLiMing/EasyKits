//
//  EasyListHeadFootModel.swift
//  EasyKit
//
//  Created by 孟利明 on 2020/6/28.
//

import UIKit

public final class EasyListHeadFootModel: NSObject {
    public static let minHeight: CGFloat = 0.000001
    
    /// headFooter所需要的数据
    public var data: Any?
    
    public private(set) var viewType: EasyListHeadFootTypeLimit
    
    public private(set) lazy var viewClass: EasyListHeaderFooterView.Type = {
        return self.viewType.viewClass()
    }()
    
    public private(set) lazy var viewID: String = {
        return self.viewType.viewID()
    }()
    
    public private(set) lazy var viewHeight: CGFloat = {
        return self.viewClass.viewHeight(headModel: self) ?? EasyListHeadFootModel.minHeight
    }()
    
    /// 父分区
    public weak var superSectionModel: EasyListSectionModel?
    
    public init(viewType: EasyListHeadFootTypeLimit, data: Any? = nil) {
        self.viewType = viewType
        self.data = data
        super.init()
    }
    
    public init<T: EasyListHeaderFooterView>(viewType: T.Type, data: Any? = nil) {
        self.viewType = EasyListHeadFootLimit<T>()
        self.data = data
        super.init()
    }
}

extension EasyListHeadFootModel: EasyListViewRegisterViewProtocol {
    public func registerViewID() -> String {
        return self.viewID
    }
    
    public func registerViewClass() -> UITableViewHeaderFooterView.Type {
        return self.viewClass
    }
}
