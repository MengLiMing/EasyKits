//
//  String+Ex.swift
//  Demo
//
//  Created by Ming on 2021/11/2.
//

import Foundation
import UIKit
import CommonCrypto

public extension String {
    func boundingRect(with size: CGSize, attributes: [NSAttributedString.Key: Any]) -> CGRect {
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        return self.boundingRect(with: size, options: options, attributes: attributes, context: nil)
    }

    func size(thatFits size: CGSize, font: UIFont, maximumNumberOfLines: Int = 0) -> CGSize {
        if isEmpty { return .zero }

        let attributes = [NSAttributedString.Key.font: font]
        var size = self.boundingRect(with: size, attributes: attributes).size
        if maximumNumberOfLines > 0 {
            size.height = min(size.height, CGFloat(maximumNumberOfLines) * font.lineHeight)
        }
        return size
    }

    func width(with font: UIFont, maximumNumberOfLines: Int = 0) -> CGFloat {
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        return self.size(thatFits: size, font: font, maximumNumberOfLines: maximumNumberOfLines).width
    }

    func height(thatFitsWidth width: CGFloat, font: UIFont, maximumNumberOfLines: Int = 0) -> CGFloat {
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        return self.size(thatFits: size, font: font, maximumNumberOfLines: maximumNumberOfLines).height
    }
    
    var md5: String {
        guard let utf8 = cString(using: .utf8) else {
            return self
        }
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(utf8, CC_LONG(utf8.count - 1), &digest)
        return digest.reduce("") { $0 + String(format: "%02x", $1)}
    }
    
    func substring(to index: Int) -> String {
        return substring(from: 0, to: index)
    }
    
    func substring(with range: NSRange) -> String {
        return substring(from: range.location, to: range.location + range.length)
    }
    
    func substring(from index: Int) -> String {
        return substring(from: index, to: self.count)
    }
    
    func substring(from fromIndex: Int, length: Int) -> String {
        return self.substring(from: fromIndex, to: fromIndex + length)
    }
    
    func substring(from fromIndex: Int, to toIndex: Int) -> String {
        let from = min(max(0, fromIndex), self.count)
        let to = min(max(0, toIndex), self.count)
        if from > to {
            return self
        }
        if from == to {
            return ""
        }
        let left = self.index(startIndex, offsetBy: from)
        let right = self.index(startIndex, offsetBy: to)
        return String(self[left..<right])
    }
    
    var attribute: NSAttributedString {
        return NSAttributedString(string: self)
    }
    
    var mutableAttributes: NSMutableAttributedString {
        return NSMutableAttributedString(string: self)
    }
}

public extension NSAttributedString {
    func height(thatFitsWidth width: CGFloat, maxHeight: CGFloat?) -> CGFloat {
        let rect = self.boundingRect(
            with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )

        if let maxHeight = maxHeight, maxHeight > 0 {
            return min(rect.height, maxHeight)
        }

        return rect.height
    }
}
