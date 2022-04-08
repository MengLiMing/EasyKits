//
//  EasySegmentedTool.swift
//  EasyKits
//
//  Created by 孟利明 on 2021/3/5.
//

import UIKit

public extension Comparable where Self: SignedNumeric {
    func transfer(to: Self, by progress: Self) -> Self {
        let progress = max(0, min(1, progress))
        return self + (to - self) * progress
    }
}

// MARK: UIColor EX
public extension UIColor {
    typealias EasyRGBA = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)

    var rgb: EasyRGBA {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return (r, g, b, a)
    }
    
    
    func transfer(to: UIColor, progress: CGFloat) -> UIColor {
        let rgba = self.rgb
        let toRgb = to.rgb
        return UIColor(red: rgba.red.transfer(to: toRgb.red, by: progress),
                       green: rgba.green.transfer(to: toRgb.green, by: progress),
                       blue: rgba.blue.transfer(to: toRgb.blue, by: progress),
                       alpha: rgba.alpha.transfer(to: toRgb.alpha, by: progress))
    }
}
