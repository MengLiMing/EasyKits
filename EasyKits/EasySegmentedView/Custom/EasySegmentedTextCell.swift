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
        
        textLabel.textColor = itemModel.normalColor.transfer(to: itemModel.selectColor, progress: itemModel.percent)
        fontSizeAnimation(itemModel)
        fontStrokeWidth(itemModel)
    }
    
    /// 字体粗细
    fileprivate func fontStrokeWidth(_ itemModel: EasySegmentedTextModel) {
        guard itemModel.maxStrokeWidth != 0 else {
            textLabel.text = itemModel.text
            return
        }
        let attributes = NSMutableAttributedString(string: itemModel.text)
        let minStrokeWidth: CGFloat = 0
        let strokeWidth: CGFloat = minStrokeWidth.transfer(to: itemModel.maxStrokeWidth, by: itemModel.percent)

        attributes.addAttribute(.strokeWidth, value: NSNumber(value: Double(strokeWidth)), range: NSMakeRange(0, itemModel.text.count))
        textLabel.attributedText = attributes
    }
    
    /// 字体大小
    fileprivate func fontSizeAnimation(_ itemModel: EasySegmentedTextModel) {
        guard itemModel.maxZoomScale != 1 else {
            textLabel.font = itemModel.font
            return
        }
        let maxFont = itemModel.maxFont
        /// 设置为最大字体 避免缩放模糊（没有根据进度生成UIFont是因为 UIFont会存在于内存中）
        textLabel.font = maxFont
        /// 所以渐变基准为maxFont.pointSize
        let targetScale = itemModel.font.pointSize.transfer(to: maxFont.pointSize, by: itemModel.percent) / maxFont.pointSize
        textLabel.transform = CGAffineTransform(scaleX: targetScale, y: targetScale)
    }
    
//    //字体变化
//    fileprivate func font(fromFont from: UIFont, toFont to: UIFont, percent: CGFloat) -> UIFont {
//        // 频繁调用 UIFont会造成内存增加
//        let resultSize = from.pointSize.transfer(to: to.pointSize, by: percent)
//        return percent <= 0.5 ? from.withSize(resultSize) : to.withSize(resultSize)
//    }
}


// MARK: EasySegmentedTextModel
open class EasySegmentedTextModel: EasySegmentBaseItemModel {
    public var text: String
    
    /// 默认的字体颜色
    public var normalColor: UIColor
    
    /// 选中的字体颜色
    public var selectColor: UIColor
    
    /// 默认的字体字号
    public var font: UIFont

    /// 字体缩放倍数
    public var maxZoomScale: CGFloat = 1
    
    fileprivate var maxFont: UIFont {
        return UIFont(descriptor: font.fontDescriptor, size: font.pointSize*maxZoomScale)
    }
    
    /// 字体描边
    public var maxStrokeWidth: CGFloat = 0
    
    public init(text: String, normalColor: UIColor, selectColor: UIColor, font: UIFont) {
        self.text = text
        self.normalColor = normalColor
        self.selectColor = selectColor
        self.font = font
    }
}
