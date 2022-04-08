//
//  String+TextAttributes.swift
//  EasyKits
//
//  Created by Ming on 2021/11/8.
//

import UIKit

#if canImport(Then)
    import Then
    extension TextAttributes: Then {}
#endif

open class TextAttributes {
    public fileprivate(set) var dictionary: [NSAttributedString.Key: Any]
    
    private var lazyParagraphStyle: NSMutableParagraphStyle {
        if dictionary[.paragraphStyle] == nil {
            dictionary[.paragraphStyle] = NSMutableParagraphStyle()
        }
        
        return dictionary[.paragraphStyle] as! NSMutableParagraphStyle
    }
    
    public init() {
        dictionary = [:]
    }
    
    @discardableResult
    open func font(_ font: UIFont?) -> Self {
        dictionary[.font] = font
        
        if let font = font, let paragraphStyle = dictionary[.paragraphStyle] as? NSMutableParagraphStyle,
           dictionary[.baselineOffset] == nil,
           paragraphStyle.minimumLineHeight > 0,
           paragraphStyle.maximumLineHeight > 0,
           paragraphStyle.minimumLineHeight == paragraphStyle.maximumLineHeight
        {
            dictionary[.baselineOffset] = (paragraphStyle.minimumLineHeight - font.lineHeight) / 4
        }
        
        return self
    }
    
    @discardableResult
    open func textColor(_ color: UIColor?) -> Self {
        dictionary[.foregroundColor] = color
        return self
    }
    
    @discardableResult
    open func backgroundColor(_ color: UIColor?) -> Self {
        dictionary[.backgroundColor] = color
        return self
    }
    
    @discardableResult
    open func kern(_ value: CGFloat) -> Self {
        dictionary[.kern] = value as NSNumber
        return self
    }
    
    @discardableResult
    open func strikethrough(_ style: NSUnderlineStyle, color: UIColor? = nil) -> Self {
        dictionary[.strikethroughStyle] = style.rawValue as NSNumber
        dictionary[.strikethroughColor] = color
        return self
    }
    
    @discardableResult
    open func underline(_ style: NSUnderlineStyle, color: UIColor? = nil) -> Self {
        dictionary[.underlineStyle] = style.rawValue as NSNumber
        dictionary[.underlineColor] = color
        return self
    }
    
    @discardableResult
    open func baselineOffset(_ value: CGFloat) -> Self {
        dictionary[.baselineOffset] = value as NSNumber
        return self
    }
    
    @discardableResult
    open func shadow(color: UIColor?, offset: CGSize, blurRadius: CGFloat) -> Self {
        let shadow = NSShadow()
        
        shadow.shadowColor = color
        shadow.shadowOffset = offset
        shadow.shadowBlurRadius = blurRadius
        
        dictionary[.shadow] = shadow
        
        return self
    }
    
    @discardableResult
    open func paragraphStyle(_ style: NSMutableParagraphStyle) -> Self {
        dictionary[.paragraphStyle] = style
        return self
    }
    
    @discardableResult
    open func alignment(_ alignment: NSTextAlignment) -> Self {
        lazyParagraphStyle.alignment = alignment
        return self
    }
    
    @discardableResult
    open func firstLineHeadIndent(_ value: CGFloat) -> Self {
        lazyParagraphStyle.firstLineHeadIndent = value
        return self
    }
    
    @discardableResult
    open func headIndent(_ value: CGFloat) -> Self {
        lazyParagraphStyle.headIndent = value
        return self
    }
    
    @discardableResult
    open func tailIndent(_ value: CGFloat) -> Self {
        lazyParagraphStyle.tailIndent = value
        return self
    }
    
    @discardableResult
    open func lineHeightMultiple(_ value: CGFloat) -> Self {
        lazyParagraphStyle.lineHeightMultiple = value
        return self
    }
    
    @discardableResult
    open func maximumLineHeight(_ value: CGFloat) -> Self {
        lazyParagraphStyle.maximumLineHeight = value
        return self
    }
    
    @discardableResult
    open func minimumLineHeight(_ value: CGFloat) -> Self {
        lazyParagraphStyle.minimumLineHeight = value
        return self
    }
    
    @discardableResult
    open func lineHeight(_ value: CGFloat) -> Self {
        if let font = dictionary[.font] as? UIFont {
            dictionary[.baselineOffset] = (value - font.lineHeight) / 4
        }

        return maximumLineHeight(value).minimumLineHeight(value)
    }
    
    @discardableResult
    open func lineSpacing(_ value: CGFloat) -> Self {
        lazyParagraphStyle.lineSpacing = value
        return self
    }
    
    @discardableResult
    open func paragraphSpacing(_ value: CGFloat) -> Self {
        lazyParagraphStyle.paragraphSpacing = value
        return self
    }
    
    @discardableResult
    open func paragraphSpacingBefore(_ value: CGFloat) -> Self {
        lazyParagraphStyle.paragraphSpacingBefore = value
        return self
    }
    
    @discardableResult
    open func lineBreakMode(_ value: NSLineBreakMode) -> Self {
        lazyParagraphStyle.lineBreakMode = value
        return self
    }
}

extension TextAttributes: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return "[\n" + dictionary.map { "\t\($0.rawValue): \($1)" }.joined(separator: "\n") + "\n]"
    }
    
    public var debugDescription: String {
        return description
    }
}

public extension NSAttributedString {
    convenience init(string: String, attributes: TextAttributes) {
        self.init(string: string, attributes: attributes.dictionary)
    }
    
    convenience init(image: UIImage, font: UIFont) {
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = .init(x: 0, y: (font.capHeight - image.size.height).rounded() / 2, width: image.size.width, height: image.size.height)
        
        self.init(attachment: attachment)
    }
}

public extension NSMutableAttributedString {
    @discardableResult
    func setAttributes(range: Range<Int>? = nil, _ config: (TextAttributes) -> Void) -> Self {
        let attributes = TextAttributes()
        
        config(attributes)
        
        var targetRange: NSRange
        
        if let range = range {
            targetRange = NSRange(range)
        } else {
            targetRange = NSRange(location: 0, length: mutableString.length)
        }
        
        setAttributes(attributes.dictionary, range: targetRange)
        
        return self
    }
    
    @discardableResult
    func setAttributes(matching: (String) throws -> Range<String.Index>, _ config: (TextAttributes) -> Void) -> Self {
        let str = mutableString as String
        
        guard let range = try? NSRange(matching(str), in: str) else { return self }
        
        let attributes = TextAttributes()
        
        config(attributes)
        
        setAttributes(attributes.dictionary, range: range)
        
        return self
    }
    
    @discardableResult
    func addAttributes(range: Range<Int>? = nil, _ config: (TextAttributes) -> Void) -> Self {
        let attributes = TextAttributes()
        
        config(attributes)
        
        var targetRange: NSRange
        
        if let range = range {
            targetRange = NSRange(range)
        } else {
            targetRange = NSRange(location: 0, length: mutableString.length)
        }
        
        addAttributes(attributes.dictionary, range: targetRange)
        
        return self
    }
    
    @discardableResult
    func addAttributes<R: RangeExpression>(matching: (String) throws -> R, _ config: (TextAttributes) -> Void) -> Self where R.Bound == String.Index {
        let str = mutableString as String
        
        guard let range = try? NSRange(matching(str), in: str) else { return self }
        
        let attributes = TextAttributes()
        
        config(attributes)
        
        addAttributes(attributes.dictionary, range: range)
        
        return self
    }
}

public extension NSString {
    func attributes(_ block: (TextAttributes) -> TextAttributes) -> NSMutableAttributedString {
        return (self as String).attributes(block)
    }
}

public extension String {
    func attributes(_ block: (TextAttributes) -> TextAttributes) -> NSMutableAttributedString {
        let attributes = block(TextAttributes())
        return NSMutableAttributedString(string: self, attributes: attributes)
    }
    
    func attributes(_ custom: TextAttributes) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: self, attributes: custom)
    }
}

public extension NSUnderlineStyle {
    static let none = NSUnderlineStyle([])
}

public func + (lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
    let final = NSMutableAttributedString(attributedString: lhs)
    final.append(rhs)
    return final
}

public func + (lhs: String, rhs: NSAttributedString) -> NSAttributedString {
    let final = NSMutableAttributedString(string: lhs)
    final.append(rhs)
    return final
}

public func + (lhs: NSAttributedString, rhs: String) -> NSAttributedString {
    let final = NSMutableAttributedString(attributedString: lhs)
    final.append(NSMutableAttributedString(string: rhs))
    return final
}
