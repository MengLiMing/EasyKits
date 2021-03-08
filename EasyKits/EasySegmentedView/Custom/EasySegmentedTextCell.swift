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
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        self.textLabel.frame = contentView.bounds
    }
    
    // MARK: Override Method
    open override func refresh(_ itemModel: EasySegmentBaseItemModel?) {
        super.refresh(itemModel)
        
        guard let itemModel = itemModel as? EasySegmentedTextModel else {
            return
        }
                
        textLabel.text = itemModel.text
        textLabel.textColor = itemModel.normalColor.transfer(to: itemModel.selectColor, progress: itemModel.percent)
        textLabel.font = font(fromFont: itemModel.normalFont, toFont: itemModel.selectFont, percent: itemModel.percent)
        
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
    public var normalFont: UIFont
    
    /// 选中的字体字号
    public var selectFont: UIFont

    
    public init(text: String, normalColor: UIColor, selectColor: UIColor, normalFont: UIFont, selectFont: UIFont) {
        self.text = text
        self.normalColor = normalColor
        self.selectColor = selectColor
        self.normalFont = normalFont
        self.selectFont = selectFont
    }
}
