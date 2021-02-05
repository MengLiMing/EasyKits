//
//  UIColor+Ex.swift
//  EasyKit
//
//  Created by 孟利明 on 2021/2/4.
//

import UIKit

public extension UIColor {
    /// 十六进制转UIColor
    /// - Parameter hexString: 十六进制色值
    /// - Parameter alpha: 透明度
    /// - Returns: UIColor
    class func hex(_ hexString: String, defaultColor: UIColor? = .white) -> UIColor {
        var hex = hexString.hasPrefix("#") ? String(hexString.dropFirst()) : hexString
        guard hex.count == 3 || hex.count == 6 else {
            return defaultColor ?? .white
        }
        if hex.count == 3 {
            for (index, char) in hex.enumerated() {
                hex.insert(char, at: hex.index(hex.startIndex, offsetBy: index * 2))
            }
        }
        
        guard let intCode = Int(hex, radix: 16) else {
            return defaultColor ?? .white
        }
        
        let red = CGFloat((intCode >> 16) & 0xFF) / 255.0
        let green = CGFloat((intCode >> 8) & 0xFF) / 255.0
        let blue = CGFloat(intCode & 0xFF) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    
    /// 颜色变化
    /// - Parameter from: 开始颜色
    /// - Parameter to: 结束颜色
    /// - Parameter percent: 百分比
    class func color(fromColor from: UIColor, toColor to: UIColor, percent: CGFloat) -> UIColor {
        if percent == 0 { return from }
        if percent == 1 { return to }
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
}
