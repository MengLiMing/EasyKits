//
//  ListBaseCollectionCell.swift
//  EasyKits
//
//  Created by Ming on 2021/11/4.
//

import Foundation
import SnapKit
import IGListKit

/// 基础绑定数据 cell
public protocol ListBindableCell: ListBindable where Self: UICollectionViewCell { }


open class LisetBaseCollectionCell: UICollectionViewCell, ListBindableCell {
    open weak var listItem: ListBaseItem?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        _initUI()
        setupUI()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _initUI()
        setupUI()
    }
    
    open func setupUI() {
    }
    
    private func _initUI() {
        contentView.backgroundColor = .white
    }
    
    open func bindViewModel(_ viewModel: Any) {
        guard let listItem = viewModel as? ListBaseItem else {
            return
        }
        self.listItem = listItem
        
        bindListItem(listItem)
    }
    
    open func bindListItem(_ listItem: ListBaseItem) {
        /// 设置圆角
        if let cornerProvider = listItem.data as? ListBaseItemCornerProvider {
            corner = cornerProvider.corner
        }
    }
}

