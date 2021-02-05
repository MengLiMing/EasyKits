//
//  EasyListHeaderFooterView.swift
//  EasyKit
//
//  Created by 孟利明 on 2020/6/28.
//

import UIKit

open class EasyListHeaderFooterView: UITableViewHeaderFooterView {
    
    public weak var model: EasyListHeadFootModel?
    public weak var listView: EasyListView?
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .white
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 子类重写
    open class func viewHeight(headModel: EasyListHeadFootModel) -> CGFloat? {
        return nil
    }
    
    open func bindView(model: EasyListHeadFootModel) {
        self.model = model
    }
}
