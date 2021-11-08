//
//  UIView+Corner.swift
//  Demo
//
//  Created by Ming on 2021/11/2.
//

import UIKit
import RxSwift
import RxCocoa

public extension UIView {
    var corner: CornerConfig {
        set {
            let oldValue = objc_getAssociatedObject(self, &AssociatedKey.view_corner_radiusConfig_key) as? CornerConfig
            objc_setAssociatedObject(self, &AssociatedKey.view_corner_radiusConfig_key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if let oldValue = oldValue,
               oldValue != newValue {
                latestRect = nil
            }
            observerRectChange()
        }
        
        get {
            (objc_getAssociatedObject(self, &AssociatedKey.view_corner_radiusConfig_key) as? CornerConfig) ?? .none
        }
    }
    
    var maskToBounds: Bool {
        set {
            let oldValue = (objc_getAssociatedObject(self, &AssociatedKey.view_corner_maskToBounds_key) as? Bool) ?? true
            objc_setAssociatedObject(self, &AssociatedKey.view_corner_maskToBounds_key, newValue, .OBJC_ASSOCIATION_ASSIGN)
            if oldValue != newValue {
                latestRect = nil
            }
            observerRectChange()
        }
        get {
            (objc_getAssociatedObject(self, &AssociatedKey.view_corner_maskToBounds_key) as? Bool) ?? true
        }
    }
}

private extension UIView {
    func synchronizedBag<T>( _ action: () -> T) -> T {
        objc_sync_enter(self)
        let result = action()
        objc_sync_exit(self)
        return result
    }
    
    var layoutSubviewsDisposeBag: DisposeBag {
        get {
            return synchronizedBag {
                if let disposeObject = objc_getAssociatedObject(self, &AssociatedKey.view_corner_layout_disposeBag) as? DisposeBag {
                    return disposeObject
                }
                let disposeObject = DisposeBag()
                objc_setAssociatedObject(self, &AssociatedKey.view_corner_layout_disposeBag, disposeObject, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return disposeObject
            }
        }
        
        set {
            synchronizedBag {
                objc_setAssociatedObject(self, &AssociatedKey.view_corner_layout_disposeBag, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }

    
    var latestRect: CGRect? {
        set {
            let oldValue = (objc_getAssociatedObject(self, &AssociatedKey.view_corner_last_rect_key) as? CGRect) ?? .zero
            objc_setAssociatedObject(self, &AssociatedKey.view_corner_last_rect_key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if let rect = newValue,
               rect != oldValue {
                let bezier = cornersPath(rect: rect, cornerConfig: corner)
                let shapeLayer = CAShapeLayer()
                shapeLayer.frame = rect
                shapeLayer.path = bezier.cgPath
                layer.mask = shapeLayer
                layer.masksToBounds = maskToBounds
            }
        }
        get {
            objc_getAssociatedObject(self, &AssociatedKey.view_corner_last_rect_key) as? CGRect
        }
    }
    
    func observerRectChange() {
        layoutSubviewsDisposeBag = DisposeBag()
        self.rx.layoutSubviews
            .takeUntil(self.rx.deallocated)
            .subscribe(onNext: {[weak self] in
                self?.latestRect = self?.bounds
            })
            .disposed(by: layoutSubviewsDisposeBag)
        layoutIfNeeded()
    }
}

public extension Reactive where Base: UIView {
    var layoutSubviews: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.layoutSubviews)).map { _ in }
      return ControlEvent(events: source)
    }
}

public class CornerConfig: Equatable {
    public let topLeft: CGFloat
    public let topRight: CGFloat
    public let bottomLeft: CGFloat
    public let bottomRight: CGFloat
    
    public init(topLeft: CGFloat = 0,
                 topRight: CGFloat = 0,
                 bottomLeft: CGFloat = 0,
                 bottomRight: CGFloat = 0) {
        self.topLeft = topLeft
        self.topRight = topRight
        self.bottomLeft = bottomLeft
        self.bottomRight = bottomRight
    }
    
    public static func top(_ radius: CGFloat) -> CornerConfig {
        .init(topLeft: radius,
              topRight: radius,
              bottomLeft: 0,
              bottomRight: 0)
    }
    
    public static func bottom(_ radius: CGFloat) -> CornerConfig {
        .init(topLeft: 0,
              topRight: 0,
              bottomLeft: radius,
              bottomRight: radius)
    }
    
    public static func left(_ radius: CGFloat) -> CornerConfig {
        .init(topLeft: radius,
              topRight: 0,
              bottomLeft: radius,
              bottomRight: 0)
    }
    
    public static func right(_ radius: CGFloat) -> CornerConfig {
        .init(topLeft: 0,
              topRight: radius,
              bottomLeft: 0,
              bottomRight: radius)
    }
    
    public static func `all`(radius: CGFloat) -> CornerConfig {
        .init(topLeft: radius,
              topRight: radius,
              bottomLeft: radius,
              bottomRight: radius)
    }
    
    public static var `none`: CornerConfig {
        return .init()
    }
    
    public static func == (lhs: CornerConfig, rhs: CornerConfig) -> Bool {
        return  lhs.topLeft == rhs.topLeft
            && lhs.topRight == rhs.topRight
            && lhs.bottomLeft == rhs.bottomLeft &&
            lhs.bottomRight == rhs.bottomRight
    }
}

private extension UIView {
    func cornersPath(rect: CGRect, cornerConfig: CornerConfig) -> UIBezierPath {
        cornersPath(rect: rect,
                    topLeft: cornerConfig.topLeft,
                    topRight: cornerConfig.topRight,
                    bottomLeft: cornerConfig.bottomLeft,
                    bottomRight: cornerConfig.bottomRight)
    }
    
    func cornersPath(rect: CGRect, top: CGFloat, bottom: CGFloat) -> UIBezierPath {
        cornersPath(rect: rect,
                    topLeft: top,
                    topRight: top,
                    bottomLeft: bottom,
                    bottomRight: bottom)
    }
    
    func cornersPath(rect: CGRect, left: CGFloat, right: CGFloat) -> UIBezierPath {
        cornersPath(rect: rect,
                    topLeft: left,
                    topRight: right,
                    bottomLeft: left,
                    bottomRight: right)
    }
    
    func cornersPath(rect: CGRect, topLeft: CGFloat, topRight: CGFloat,  bottomLeft: CGFloat, bottomRight: CGFloat) -> UIBezierPath {
        if topRight == 0, topLeft == 0, bottomLeft == 0, bottomRight == 0 {
            return UIBezierPath(rect: rect)
        }
        let path = UIBezierPath()
        if topRight != 0 {
            path.move(to: CGPoint(x: rect.maxX-topRight, y: rect.minY))
            path.addArc(withCenter: CGPoint(x: rect.maxX-topRight, y: rect.minY + topRight), radius: topRight, startAngle: .pi / 2, endAngle: 0, clockwise: true)
        } else {
            path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
        }
        
        if bottomRight != 0 {
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - bottomRight))
            path.addArc(withCenter: CGPoint(x: rect.maxX - bottomRight, y: rect.maxY - bottomRight), radius: bottomRight, startAngle: 0, endAngle: .pi / 2, clockwise: true)
        } else {
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        }
        
        if bottomLeft != 0 {
            path.addLine(to: CGPoint(x: rect.minX + bottomLeft, y: rect.maxY))
            path.addArc(withCenter: CGPoint(x: rect.minX + bottomLeft, y: rect.maxY - bottomLeft), radius: bottomLeft, startAngle: .pi/2, endAngle: .pi, clockwise: true)
        } else {
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        }
        
        if topLeft != 0 {
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + topLeft))
            path.addArc(withCenter: CGPoint(x: rect.minX + topLeft, y: rect.minY + topLeft), radius: topLeft, startAngle: .pi, endAngle: .pi * 3 / 2, clockwise: true)
        } else {
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        }
        path.close()
        
        return path
    }
}


private enum AssociatedKey {
    static var view_corner_last_rect_key: UInt8 = 0
    static var view_corner_radiusConfig_key: UInt8 = 0
    static var view_corner_maskToBounds_key: UInt8 = 0
    static var view_corner_layout_disposeBag: UInt8 = 0
}

