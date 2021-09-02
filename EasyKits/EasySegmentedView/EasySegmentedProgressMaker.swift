//
//  EasySegmentedProgressMaker.swift
//  EasyKits
//
//  Created by 孟利明 on 2021/2/26.
//

import Foundation

final class EasySegmentedProgressMaker {
    var duration: TimeInterval = 0
    var progressHandler: ((CGFloat)->())?
    var completedHandler: (()->())?
    fileprivate var displayLink: CADisplayLink?
    
    private var lastTime: TimeInterval = 0

    func start() {
        guard duration > 0 else {
            return
        }
        stop()
        displayLink = CADisplayLink(target: self, selector: #selector(displayLinkHandler(sender:)))
        displayLink?.add(to: .main, forMode: .common)
    }

    func stop() {
        if displayLink == nil {
            return
        }
        progressHandler?(1)
        displayLink?.invalidate()
        displayLink = nil
        completedHandler?()
        lastTime = 0
        progressHandler = nil
        completedHandler = nil
    }

    @objc private func displayLinkHandler(sender: CADisplayLink) {
        if lastTime == 0 {
            lastTime = sender.timestamp
        }
        let progress = (sender.timestamp - lastTime)/duration
        if progress >= 1 {
            stop()
        }else {
            progressHandler?(CGFloat(progress))
        }
    }
    
    deinit {
        displayLink?.invalidate()
        displayLink = nil
    }
}
