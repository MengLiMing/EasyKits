//
//  EasySegmentedBaseCell.swift
//  EasyKits
//
//  Created by 孟利明 on 2021/2/25.
//
import UIKit

public enum ViewAnimation {
    case none
    case normal(_ duration: TimeInterval)
    case spring(_ duration: TimeInterval, damping: CGFloat, velocity: CGFloat)
    
    public static var normal: ViewAnimation {
        return ViewAnimation.normal(0.3)
    }
    
    public static var spring: ViewAnimation {
        return ViewAnimation.spring(0.3, damping: 0.7, velocity: 2)
    }
    
    public func animation(_ animation: @escaping () -> Void, completion: ((Bool) -> Void)?) {
        switch self {
        case let .normal(duration):
            UIView.animate(withDuration: duration, animations: animation, completion: completion)
        case let .spring(duration, damping: damping, velocity: velocity):
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: .curveEaseInOut, animations: animation, completion: completion)
        default:
            animation()
            completion?(true)
        }
    }
    
    public var duration: TimeInterval {
        switch self {
        case let .normal(duration):
            return duration
        case let .spring(duration, damping: _, velocity: _):
            return duration
        default:
            return 0
        }
    }
}
