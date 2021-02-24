//
//  NSMutableAttributedString+Ex.swift
//  EasyKits
//
//  Created by 孟利明 on 2021/2/24.
//

import Foundation

public extension NSMutableAttributedString {
    /// 修改段落样式
    /// 计算高度的话可将 lineBreakMode 设置为 .byCharWrapping 否则计算高度不准确
    /// - Parameter lineSpacing: 行间距
    /// - Returns: NSMutableAttributedString
    @discardableResult
    func setParagraphStyle(lineSpacing: CGFloat,
                           alignment: NSTextAlignment = .left,
                           lineBreakMode: NSLineBreakMode = .byTruncatingTail) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineBreakMode = lineBreakMode
        paragraphStyle.alignment = alignment
        addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSMakeRange(0, length))
        return self
    }
    
    /// 修改字号
    /// - Parameters:
    ///   - font: 字号
    ///   - range: 修改范围
    /// - Returns: NSMutableAttributedString
    @discardableResult
    func setFont(_ font: UIFont,
                 range: NSRange? = nil) -> NSMutableAttributedString {
        addAttribute(NSAttributedString.Key.font, value: font, range: range ?? NSMakeRange(0, length))
        return self
    }
    
    /// 修改字体颜色
    /// - Parameters:
    ///   - color: 字体颜色
    ///   - range: 修改范围
    /// - Returns: NSMutableAttributedString
    @discardableResult
    func setFontColor(_ color: UIColor,
                      range: NSRange? = nil) -> NSMutableAttributedString {
        addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range ?? NSMakeRange(0, length))
        return self
    }
    
    /// 富文本链接
    /// - Parameters:
    ///   - link: 链接地址
    ///   - range: 范围
    /// - Returns: NSMutableAttributedString
    @discardableResult
    func setLink(_ link: String,
                 range: NSRange? = nil) -> NSMutableAttributedString {
        addAttribute(.link, value: link, range: range ?? NSMakeRange(0, length))
        return self
    }
    
    /// 插入图片
    /// - Parameters:
    ///   - image: 要插入的图片
    ///   - index: 插入位置（可选：默认为0）
    ///   - imageSize: 图片尺寸（可选：默认为图片大小）
    ///   - imageOffSet: 图片偏移量（可选：默认为zero）
    /// - Returns: NSMutableAttributedString
    @discardableResult
    func setImage(_ image: UIImage?,
                  index: Int = 0,
                  imageSize: CGSize? = nil,
                  imageOffSet: CGPoint = CGPoint.zero) -> NSMutableAttributedString {
        guard let insertImage = image else {
            return self
        }
        
        let imageMent = NSTextAttachment()
        imageMent.image = insertImage
        imageMent.bounds = CGRect(x: imageOffSet.x,
                                  y: imageOffSet.y,
                                  width: imageSize?.width ?? insertImage.size.width,
                                  height: imageSize?.height ?? insertImage.size.height)
        let imageAttribute = NSAttributedString(attachment: imageMent)
        insert(imageAttribute, at: index)
        return self
    }
    
    /// 修改（文字、图片）基线位置
    /// - Parameters:
    ///   - baselineOffset: 基线位置
    ///   - range: 修改范围
    /// - Returns: NSMutableAttributedString
    @discardableResult
    func setBaselineOffset(_ baselineOffset: NSNumber,
                           range: NSRange? = nil) -> NSMutableAttributedString {
        addAttribute(NSAttributedString.Key.baselineOffset, value: baselineOffset, range: range ?? NSMakeRange(0, length))
        return self
    }
    
    
    /// 添加删除线
    /// - Parameter strikethroughStyle: 下划线style， 可调节删除线粗细，双实线效果
    /// - Parameter strikethroughColor: 颜色
    /// - Parameter range: 修改范围
    @discardableResult
    func setStrikeThrough(strikethroughStyle: NSUnderlineStyle = .single,
                         strikethroughColor: UIColor,
                         range: NSRange? = nil) -> NSMutableAttributedString {
        let range = range ?? NSMakeRange(0, length)
        addAttribute(NSAttributedString.Key.strikethroughStyle, value: strikethroughStyle.rawValue, range: range)
        addAttribute(NSAttributedString.Key.strikethroughColor, value: strikethroughColor, range: range)
        addAttribute(NSAttributedString.Key.baselineOffset, value: 0, range: range)
        return self
    }
}
