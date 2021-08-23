//
//  SyncScrollContext.swift
//  EasyKit
//
//  Created by 孟利明 on 2020/10/16.
//

import UIKit
import RxSwift
import RxCocoa

/// 内外scrollView的上下文
public final class SyncScrollContext {
    /// 刷新类型
    public enum RefreshType {
        /// 外部
        case outer
        /// 内部
        case inner
    }
    
    public var refreshType: RefreshType {
        didSet {
            if refreshType == .outer {
                self.resetOuterBounces(self.outerItem?.scrollView.contentOffset ?? .zero)
            }
        }
    }
    /// 最大偏移 - 悬停时的偏移量
    public var maxOffsetY: CGFloat = 0
    /// 外部偏移
    fileprivate var outerOffset: CGPoint = .zero
    /// 内部偏移
    fileprivate var innerOffset: CGPoint = CGPoint.zero
    /// 悬停状态
    fileprivate var isHover = BehaviorRelay(value: false)
    
    fileprivate var disposeBag = DisposeBag()
    
    public init(refreshType: RefreshType = .outer) {
        self.refreshType = refreshType
    }
    
    /// ContainerView
    public weak var containerView: SyncScrollContainer?
    
    /// 悬停状态改变
    public var isHoverChanged: Driver<Bool> {
        return self.isHover
            .asDriver()
            .distinctUntilChanged()
    }
    
    /// 外部scrollView
    fileprivate var outerDisposeBag = DisposeBag()
    public weak var outerItem: SyncOuterScroll? {
        didSet {
            outerDisposeBag = DisposeBag()
            guard let outerItem = outerItem else {
                return
            }
            outerItem.scrollView.rx
                .kvo_contentOffset
                .observe(on: MainScheduler.asyncInstance)
                .asDriver(onErrorJustReturn: .zero)
                .distinctUntilChanged()
                .drive(onNext: {[weak self] contentOffset in
                    self?.outerOffsetChanged(contentOffset)
                })
                .disposed(by: outerDisposeBag)
            
            outerItem.scrollView.rx
                .kvo_contentSize
                .distinctUntilChanged()
                .subscribe(onNext: {[weak self] _ in
                    self?.changeHover()
                })
                .disposed(by: outerDisposeBag)
        }
    }
    
    fileprivate func outerOffsetChanged(_ contentOffset: CGPoint) {
        guard let outer = outerItem else {
            return
        }
        self.resetOuterBounces(contentOffset)
        
        /// container内部scrollView的偏移>0 外部偏移量保持为最大偏移
        if let innerItem = innerItem, innerOffset.y > innerItem.scrollView.sync_minY {
            outer.scrollView.contentOffset.y = maxOffsetY
        }
        outerOffset = outer.scrollView.contentOffset

        changeHover()
    }
    
    fileprivate func resetOuterBounces(_ contentOffset: CGPoint) {
        guard let outer = self.outerItem else {
            return
        }
        switch self.refreshType {
        case .inner:
            outer.scrollView.bounces = false
        case .outer:
            outer.scrollView.bounces = contentOffset.y <= (self.maxOffsetY)/2
        }
    }
    
    fileprivate func changeHover() {
        if self.outerOffset.y >= self.maxOffsetY {/// 处于悬停状态
            self.isHover.accept(true)
        } else {
            if self.isHover.value != false {
                self.containerView?.resetContainerItems({ item in
                    item.scrollView.contentOffset = .init(x: 0, y: item.scrollView.sync_minY)
                })
            }
            self.isHover.accept(false)
        }
    }

    /// Container内部Item
    fileprivate var innerDisposeBag = DisposeBag()
    public weak var innerItem: SyncInnerScroll? {
        didSet {
            self.innerDisposeBag = DisposeBag()
            guard let innerItem = innerItem else {
                return
            }
            innerItem.scrollView.rx
                .kvo_contentOffset
                .observe(on: MainScheduler.asyncInstance)
                .asDriver(onErrorJustReturn: .zero)
                .distinctUntilChanged()
                .drive(onNext: { [weak self] contentOffset in
                    self?.innerOffsetChanged(contentOffset)
                })
                .disposed(by: self.innerDisposeBag)
        }
    }
    
    fileprivate func innerOffsetChanged(_ contentOffset: CGPoint) {
        guard let inner = innerItem,
              let outer = outerItem else {
            return
        }
        switch refreshType {
        case .inner:
            if outerOffset.y < maxOffsetY  {
                if outerOffset.y > outer.scrollView.sync_minY {
                    fixedScrollViewToMinY(inner.scrollView)
                }
            }
        case .outer:
            if outerOffset.y < maxOffsetY {
                fixedScrollViewToMinY(inner.scrollView)
            }
        }
                    
        innerOffset = inner.scrollView.contentOffset

        outerItem?.scrollView.scrollsToTop = contentOffset.y <= inner.scrollView.sync_minY
        innerItem?.scrollView.scrollsToTop = contentOffset.y > inner.scrollView.sync_minY
    }
    
    fileprivate func fixedScrollViewToMinY(_ scrollView: UIScrollView?) {
        guard let scrollView = scrollView else {
            return
        }
        scrollView.contentOffset.y = scrollView.sync_minY
    }
}
