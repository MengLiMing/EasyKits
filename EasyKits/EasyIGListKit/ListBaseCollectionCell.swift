//
//  ListBaseCollectionCell.swift
//  EasyKits
//
//  Created by zkkj on 2021/11/4.
//

import Foundation
import SnapKit
import RxSwift
import IGListKit

open class ListBindableCell: UICollectionViewCell & ListBindable {
    open var separatorStyle: ListItemSeparatorStyle = .none() {
        didSet {
            updateSeparatorStyle()
        }
    }
    
    open lazy var separatorLine = UIView(frame: .zero)
    
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
    
    private func _initUI() {
        contentView.backgroundColor = .white
    }
    
    open func setupUI() {
        
    }
    
    private func updateSeparatorStyle() {
        guard separatorStyle.position != .none else {
            separatorLine.isHidden = true
            separatorLine.removeFromSuperview()
            return
        }
        separatorLine.isHidden = false
        separatorLine.backgroundColor = separatorStyle.color
        if separatorLine.superview == nil {
            contentView.addSubview(separatorLine)
        }
        separatorLine.snp.remakeConstraints { maker in
            maker.height.equalTo(separatorStyle.height)
            switch separatorStyle.position {
            case .top:
                maker.leading.equalTo(separatorStyle.margin.left)
                maker.trailing.equalTo(-separatorStyle.margin.right)
                maker.top.equalTo(separatorStyle.margin.top)
            case .right:
                maker.trailing.equalTo(-separatorStyle.margin.right)
                maker.bottom.equalTo(-separatorStyle.margin.bottom)
                maker.top.equalTo(separatorStyle.margin.top)
            case .left:
                maker.leading.equalTo(separatorStyle.margin.left)
                maker.bottom.equalTo(-separatorStyle.margin.bottom)
                maker.top.equalTo(separatorStyle.margin.top)
            case .bottom:
                maker.leading.equalTo(separatorStyle.margin.left)
                maker.trailing.equalTo(-separatorStyle.margin.right)
                maker.bottom.equalTo(-separatorStyle.margin.bottom)
            case .none:
                break
            }
        }
    }
    
    open func bindViewModel(_ viewModel: Any) {}
}

open class ListBaseCollectionCell<T: ListBaseItemDataType>: ListBindableCell {
    open weak var viewModel: ListBaseItem?
    
    open var bindDisposeBag = DisposeBag()
    
    open var data: T? {
        return viewModel?.data as? T
    }
    
    open override func setupUI() {
        super.setupUI()
        contentView.backgroundColor = .white
    }
    
    open override func bindViewModel(_ viewModel: Any) {
        super.bindViewModel(viewModel)
        guard let viewModel = viewModel as? ListBaseItem else {
            return
        }
        self.viewModel = viewModel
        /// 设置分割线
        if let separatorProvider = viewModel.data as? ListBaseItemSeparatorStyleProvider {
            separatorStyle = separatorProvider.separatorStyle
        }
        /// 设置圆角
        if let cornerProvider = viewModel.data as? ListBaseItemCornerProvider {
            corner = cornerProvider.corner
        }
        if let data = self.data {
            bindDisposeBag = DisposeBag()
            bindData(data)
        }
    }
    
    /// 子类重写此方法 绑定数据
    open func bindData(_ data: T) {
        
    }
}


public struct ListItemSeparatorStyle {
    public enum Position {
        case none
        case top
        case left
        case right
        case bottom
    }
    
    /// 分割线方位
    public let position: Position
    
    /// 高度
    public let height: CGFloat
    
    /// 颜色
    public let color: UIColor
    
    /// margin - 会根据Position忽略一个方向的数值，如top 则会忽略bottom方向的值
    public let margin: UIEdgeInsets
    
    public static var defaultColor = UIColor(red: 233/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1)
    
    public init(position: Position = .bottom,
         height: CGFloat = 0.5,
         color: UIColor = defaultColor,
         margin: UIEdgeInsets = .zero) {
        self.position = position
        self.height = height
        self.color = color
        self.margin = margin
    }
    
    public static func top(height: CGFloat = 0.5,
                    color: UIColor = defaultColor,
                    margin: UIEdgeInsets = .zero) -> ListItemSeparatorStyle {
        return .init(position: .top, height: height, color: color, margin: margin)
    }
    
    public static func right(height: CGFloat = 0.5,
                      color: UIColor = defaultColor,
                      margin: UIEdgeInsets = .zero) -> ListItemSeparatorStyle {
        return .init(position: .right, height: height, color: color, margin: margin)
    }
    
    public static func bottom(height: CGFloat = 0.5,
                       color: UIColor = defaultColor,
                       margin: UIEdgeInsets = .zero) -> ListItemSeparatorStyle {
        return .init(position: .bottom, height: height, color: color, margin: margin)
    }
    
    public static func left(height: CGFloat = 0.5,
                     color: UIColor = defaultColor,
                     margin: UIEdgeInsets = .zero) -> ListItemSeparatorStyle {
        return .init(position: .left, height: height, color: color, margin: margin)
    }
    
    public static func none() -> ListItemSeparatorStyle {
        return .init(position: .none)
    }
}

