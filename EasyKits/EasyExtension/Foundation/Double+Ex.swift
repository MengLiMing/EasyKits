//
//  Double+Ex.swift
//  Demo
//
//  Created by Ming on 2021/11/2.
//

import Foundation

public extension Double {
    /// 处理数值精度
    ///
    /// - Parameters:
    ///   - scale: 保留位数
    ///   - divide: 除以的位数
    ///   - roundingMode: 默认四舍五入
    /// - Returns: 处理后的结果
    func formatNumber(afterPoint scale: Int16,
                      divide: Double = 1,
                      roundingMode: NSDecimalNumber.RoundingMode = .plain) -> String {
        let roundingBehavior = NSDecimalNumberHandler(
            roundingMode: roundingMode,
            scale: scale,
            raiseOnExactness: false,
            raiseOnOverflow: false,
            raiseOnUnderflow: false,
            raiseOnDivideByZero: true)
        
        let decimalNumber = NSDecimalNumber.init(value: self)
        let divideNumber = NSDecimalNumber.init(value: divide)
        
        let result = decimalNumber.dividing(by: divideNumber, withBehavior: roundingBehavior)
        
        return result.stringValue
    }
}
