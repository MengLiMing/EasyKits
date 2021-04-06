//
//  EasySegmentedTextCell.swift
//  EasyKits
//
//  Created by 孟利明 on 2021/2/26.
//

import UIKit

open class EasySegmentedTextCell: EasySegmentedBaseCell {
    fileprivate lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    
    required public init(frame: CGRect) {
        super.init(frame: frame)
        setSubviews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private Method
    fileprivate func setSubviews() {
        addSubview(self.textLabel)
        self.textLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self.textLabel, attribute: .centerX, relatedBy: .equal, toItem: self.contentView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.textLabel, attribute: .centerY, relatedBy: .equal, toItem: self.contentView, attribute: .centerY, multiplier: 1, constant: 0)
        ])
    }
    
    // MARK: Override Method
    open override func refresh(_ itemModel: EasySegmentBaseItemModel?) {
        super.refresh(itemModel)
        
        guard let itemModel = itemModel as? EasySegmentedTextModel else {
            return
        }
        
        textLabel.text = itemModel.text
        textLabel.textColor = itemModel.normalColor.transfer(to: itemModel.selectColor, progress: itemModel.percent)
        fontAnimation(itemModel)
    }
    
    fileprivate func fontAnimation(_ itemModel: EasySegmentedTextModel) {
        if let maxZoomScale = itemModel.maxZoomScale, maxZoomScale != 1 {
            let maxFont = UIFont(descriptor: itemModel.normalFont.fontDescriptor, size: itemModel.normalFont.pointSize*maxZoomScale)
            /// 设置为最大字体 避免缩放模糊
            textLabel.font = maxFont
            /// 所以渐变基准为maxFont.pointSize
            let targetScale = itemModel.normalFont.pointSize.transfer(to: maxFont.pointSize, by: itemModel.percent) / maxFont.pointSize
            textLabel.transform = CGAffineTransform(scaleX: targetScale, y: targetScale)
        } else {
            /// 字体缩放不建议使用 withSize(_ fontSize: CGFloat) -> UIFont,UIFont会造成内存增加
            if itemModel.percent >= 1 {
                textLabel.font = itemModel.selectFont
            } else {
                textLabel.font = itemModel.normalFont
            }
        }
    }
    
    //字体变化
    fileprivate func font(fromFont from: UIFont, toFont to: UIFont, percent: CGFloat) -> UIFont {
        /// 此处只是简单处理 需要特殊效果的可以自定义
        let resultSize = from.pointSize.transfer(to: to.pointSize, by: percent)
        return percent <= 0.5 ? from.withSize(resultSize) : to.withSize(resultSize)
    }
}


// MARK: EasySegmentedTextModel
open class EasySegmentedTextModel: EasySegmentBaseItemModel {
    
    public var text: String
    
    /// 默认的字体颜色
    public var normalColor: UIColor
    
    /// 选中的字体颜色
    public var selectColor: UIColor
    
    /// 默认的字体字号
    public let normalFont: UIFont
    
    /// 选中的字体字号
    public var selectFont: UIFont! {
        didSet {
            maxZoomScale = nil
        }
    }
    
    /// 字体缩放倍数
    public var maxZoomScale: CGFloat?
    
    public init(text: String, normalColor: UIColor, selectColor: UIColor, normalFont: UIFont) {
        self.text = text
        self.normalColor = normalColor
        self.selectColor = selectColor
        self.normalFont = normalFont
        self.selectFont = normalFont
    }
}
