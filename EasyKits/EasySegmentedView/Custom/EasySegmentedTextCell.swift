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
        
        textLabel.textColor = color(fromColor: itemModel.normalColor, toColor: itemModel.selectColor, percent: itemModel.percent)
        textLabel.font = font(fromFont: itemModel.normalFont, toFont: itemModel.selectFont, percent: itemModel.percent)
        
    }
    
    //颜色变化
    fileprivate func color(fromColor from: UIColor, toColor to: UIColor, percent: CGFloat) -> UIColor {
        if from == to { return from }
        //起始
        var fromRed: CGFloat = 0
        var fromGreen: CGFloat = 0
        var fromBlue: CGFloat = 0
        var fromAlpha: CGFloat = 0
        
        //结束
        var toRed: CGFloat = 0
        var toGreen: CGFloat = 0
        var toBlue: CGFloat = 0
        var toAlpha: CGFloat = 0
        
        if from.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha) &&
            to.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha) {
            
            let resultRed = (toRed - fromRed) * percent + fromRed
            let resultGreen = (toGreen - fromGreen) * percent + fromGreen
            let resultBlue = (toBlue - fromBlue) * percent + fromBlue
            let resultAlpha = (toAlpha - fromAlpha) * percent + fromAlpha
            
            return UIColor(red: resultRed, green: resultGreen, blue: resultBlue, alpha: resultAlpha)
        }
        
        return to
    }
    
    //字体变化
    fileprivate func font(fromFont from: UIFont, toFont to: UIFont, percent: CGFloat) -> UIFont {
        if from == to { return from }
        let fromSize = from.pointSize
        let toSize = to.pointSize
        
        let resultSize = (toSize - fromSize) * percent + fromSize
        
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
