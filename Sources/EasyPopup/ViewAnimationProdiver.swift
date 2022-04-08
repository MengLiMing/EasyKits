//
//  EasySegmentedBaseCell.swift
//  EasyKits
//
//  Created by 孟利明 on 2021/2/25.
//

import UIKit

public protocol ViewAnimationProdiver {
    var animation: ViewAnimation { get }
    var startPosition: ViewPosition { get }
    var endPosition: ViewPosition { get }
    var transfers: [ViewTransfer] { get }
}

public extension ViewAnimationProdiver {
    func startAnimation(_ view: UIView?, completion: ((Bool) -> Void)? = nil) {
        guard let view = view,
              view.superview != nil else {
            return
        }
        view.layout(from: startPosition, to: endPosition)
            .layoutAnimation(by: animation, transfers: transfers, completion: completion)
    }
    
    func endAnimation(_ view: UIView?, completion: ((Bool) -> Void)? = nil) {
        guard let view = view,
              view.superview != nil else {
            return
        }
        view.layout(by: startPosition)
            .layoutAnimation(by: animation, transfers: transfers, isStart: false, completion: completion)
    }
}

extension ViewLayout where Self: UIView {
    func layoutAnimation(by animation: ViewAnimation,
                         transfers: [ViewTransfer],
                         isStart: Bool = true,
                         completion: ((Bool) -> Void)? = nil) {
        if isStart {
            transfers.forEach { $0.transferFrom(self) }
        }
        animation.animation {
            self.superViewLayoutIfNeeded()
            if isStart {
                transfers.forEach { $0.transferTo(self) }
            } else {
                transfers.forEach { $0.transferFrom(self) }
            }
        } completion: { fininshed in
            completion?(fininshed)
        }
    }
}

public struct CustomViewAnimation: ViewAnimationProdiver {
    public let animation: ViewAnimation
    public let startPosition: ViewPosition
    public let endPosition: ViewPosition
    public let transfers: [ViewTransfer]
    
    public init(animation: ViewAnimation = .normal,
                startPosition: ViewPosition,
                endPosition: ViewPosition,
                transfers: [ViewTransfer] = []) {
        self.animation = animation
        self.startPosition = startPosition
        self.endPosition = endPosition
        self.transfers = transfers
    }
}
