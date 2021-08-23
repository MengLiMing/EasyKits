//
//  EasyCarouseView.swift
//  EasyKits
//
//  Created by 孟利明 on 2021/2/24.
//

import Foundation

public protocol EasyCarouseViewDataSource: AnyObject {
    /// 自定义cell
    /// - Parameters:
    ///   - carouseView: 轮播view
    ///   - indexPath: IndexPath
    ///   - itemIndex: 对应数据源的下标
    func carouseView(_ carouseView: EasyCarouseView, cellForItemAt indexPath: IndexPath, itemIndex: Int) -> UICollectionViewCell
    
    /// 数据数量
    func numberOfItems(in caroueView: EasyCarouseView) -> Int
}

public protocol EasyCarouseViewDelegate: AnyObject {
    /// 点击下标
    func carouseView(_ carouseView: EasyCarouseView, selectedAt index: Int)
    /// 下标改变回调
    func carouseView(_ carouseView: EasyCarouseView, indexChanged index: Int)
    /// 滑动scale回调
    func carouseView(_ carouseView: EasyCarouseView, from fromIndex: Int, to toIndex: Int, scale: CGFloat)
}

public extension EasyCarouseViewDelegate {
    /// 点击下标
    func carouseView(_ carouseView: EasyCarouseView, selectedAt index: Int) { }
    /// 下标改变回调
    func carouseView(_ carouseView: EasyCarouseView, indexChanged index: Int) { }
    /// 滑动scale回调
    func carouseView(_ carouseView: EasyCarouseView, from fromIndex: Int, to toIndex: Int, scale: CGFloat) { }
}

/// 轮播 - 支持自定义view
open class EasyCarouseView: UICollectionView {
    /// 方向
    public enum Direction {
        case horizontal
        case vertical
        
        var scrollDirection: UICollectionView.ScrollDirection {
            switch self {
            case .horizontal:
                return .horizontal
            case .vertical:
                return .vertical
            }
        }
    }
    
    public weak var carouseDataSource: EasyCarouseViewDataSource?
    
    public weak var carouseDelegate: EasyCarouseViewDelegate? {
        didSet {
            /// 首次下标
            self.changePageIndex()
        }
    }
    
    public var cycleTime: TimeInterval = 3 {
        didSet {
            setupTimer()
        }
    }
    
    public private(set) var direction: Direction

    /// isLoop == true时 扩大的倍数
    fileprivate let multiple: Int = 100
    
    fileprivate weak var timer: Timer?
    
    fileprivate var totalItemsCount: Int = 0
    
    fileprivate weak var flowLayout: UICollectionViewFlowLayout?
    
    /// 上一次滚动的偏移
    fileprivate var lastTimeOffset: CGFloat = 0
    
    /// 循环
    public var isLoop: Bool = true {
        didSet {
            if oldValue != self.isLoop {
                resetScrollView()
            }
        }
    }
    
    /// 自动
    public var isAuto: Bool = true {
        didSet {
            if oldValue != self.isAuto {
                /// 自动必定循环
                if self.isAuto {
                    self.isLoop = true
                } else {
                    invalidateTimer()
                }
            }
        }
    }
    
    public init(direction: Direction) {
        self.direction = direction
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = self.direction.scrollDirection
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        super.init(frame: .zero, collectionViewLayout: layout)
        self.flowLayout = layout
        self.delegate = self
        self.dataSource = self
        self.bounces = false
        self.isPagingEnabled = true
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.scrollsToTop = false
        self.backgroundColor = .clear
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func resetScrollView() {
        self.totalItemsCount = sourceCount * (self.isLoop ? multiple : 1)
        if totalItemsCount > 1 {
            self.isScrollEnabled = true
        } else {
            self.isScrollEnabled = false
            self.isAuto = false
        }
        super.reloadData()
        self.changePageIndex()
        if isAuto {
            setupTimer()
        }
    }
    
    fileprivate var sourceCount: Int {
        return self.carouseDataSource?.numberOfItems(in: self) ?? 0
    }
    
    fileprivate func scroll(to index: Int) {
        self.safeScrollToItem(at: IndexPath(row: index, section: 0), at: UICollectionView.ScrollPosition.init(rawValue: 0), animated: true)
    }
    
    fileprivate func safeScrollToItem(at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        guard indexPath.item >= 0 &&
                indexPath.section >= 0 &&
                indexPath.section < numberOfSections &&
                indexPath.item < numberOfItems(inSection: indexPath.section) else {
            return
        }
        scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
    }
    
    fileprivate func judgeScrollView(by contentOffset: CGPoint) {
        guard isLoop && totalItemsCount > 0 else {
            return
        }
        var targetIndex: Int?
        switch direction {
        case .horizontal:
            if contentOffset.x <= 0 {
                targetIndex = sourceCount * Int(multiple/2)
            } else if contentOffset.x >= contentSize.width - self.frame.size.width {
                targetIndex = sourceCount * Int(multiple/2) + sourceCount - 1
            }
        case .vertical:
            if contentOffset.y <= 0 {
                targetIndex = sourceCount * Int(multiple/2)
            } else if contentOffset.y >= contentSize.height - self.frame.size.height {
                targetIndex = sourceCount * Int(multiple/2) + sourceCount - 1
            }
        }
        if let targetIndex = targetIndex {
            self.safeScrollToItem(at: IndexPath(row: targetIndex, section: 0), at: UICollectionView.ScrollPosition.init(rawValue: 0), animated: false)
        }
    }
    
    // MARK: override
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        self.flowLayout?.itemSize = self.frame.size
        self.judgeScrollView(by: contentOffset)
    }
    
    public override func reloadData() {
        self.resetScrollView()
    }
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        /// 移除
        if newSuperview == nil {
            self.invalidateTimer()
        }
        super.willMove(toSuperview: newSuperview)
    }
    
    deinit {
        self.delegate = nil
        self.dataSource = nil
    }
}

public extension EasyCarouseView {
    func currentPage() -> Int {
        let offsetIndex = self.currentRow()
        let pageIndex = self.pageIndex(by: offsetIndex)
        return pageIndex
    }
    
    /// indexPath 转下标
    func pageIndex(by indexPath: IndexPath) -> Int {
        return self.pageIndex(by: indexPath.row)
    }
    
    func pageIndex(by row: Int) -> Int {
        if sourceCount == 0 {
            return 0
        }
        return row % sourceCount
    }
    
    func currentRow() -> Int {
        if self.frame.size.width == 0 || self.frame.size.height == 0 {
            return 0
        }
        guard let layout = self.flowLayout else {
            return 0
        }
        
        var index = 0
        if direction == .horizontal {
            index = Int((self.contentOffset.x + layout.itemSize.width * 0.5)/layout.itemSize.width)
        } else {
            index = Int((self.contentOffset.y + layout.itemSize.height * 0.5)/layout.itemSize.height)
        }
        return index
    }
    
    /// 暂停
    func pause() {
        if isAuto {
            invalidateTimer()
        }
    }
    
    /// 恢复
    func restore() {
        if isAuto {
            setupTimer()
        }
    }
}

/// Timer
fileprivate extension EasyCarouseView {
    @objc func automaticScroll() {
        if isAuto == false { return }
        if totalItemsCount == 0 { return }
        let currentIndex = self.currentRow()
        let targetIndex = currentIndex + 1
        self.scroll(to: targetIndex)
    }
    
    func setupTimer() {
        invalidateTimer()
        let createTimer = Timer.scheduledTimer(timeInterval: cycleTime, target: self, selector: #selector(automaticScroll), userInfo: nil, repeats: true)
        timer = createTimer
        RunLoop.main.add(createTimer, forMode: .common)
    }
    
    func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
}

extension EasyCarouseView {
    fileprivate func changePageIndex() {
        if sourceCount == 0 { return }
        let offsetIndex = self.currentRow()
        let pageIndex = self.pageIndex(by: offsetIndex)
        self.carouseDelegate?.carouseView(self, indexChanged: pageIndex)
    }
    
    fileprivate func changeScale() {
        switch self.direction {
        case .horizontal:
            changeScaleH()
        case .vertical:
            changeScaleV()
        }
    }
    
    fileprivate func changeScaleH() {
        guard self.frame.size.width > 0, sourceCount > 0 else {
            return
        }
        let isToRight = self.contentOffset.x > lastTimeOffset
        let index = Int(self.contentOffset.x / self.frame.size.width)
        /// 相对下标
        let relativeIndex = index % sourceCount
        /// 相对偏移
        let relativeOffSetX = self.contentOffset.x - CGFloat(index) * self.frame.size.width
        /// scale
        var scale = relativeOffSetX / self.frame.size.width
        
        var toIndex: Int!
        var fromIndex: Int!
        
        if isToRight {
            fromIndex = relativeIndex
            if scale == 0 {
                fromIndex -= 1
                scale = 1
            }
            toIndex = fromIndex + 1
            if toIndex >= sourceCount {
                toIndex -= sourceCount
            }
        } else {
            fromIndex = relativeIndex - 1
            toIndex = relativeIndex
            scale = 1 - scale
        }
        fromIndex = correct(index: fromIndex)
        toIndex = correct(index: toIndex)
        self.carouseDelegate?.carouseView(self, from: fromIndex, to: toIndex, scale: scale)
        
        lastTimeOffset = self.contentOffset.x
    }
    
    fileprivate func changeScaleV() {
        guard self.frame.size.height > 0, sourceCount > 0 else {
            return
        }
        let isTopBottom = self.contentOffset.y > lastTimeOffset
        let index = Int(self.contentOffset.y / self.frame.size.height)
        /// 相对下标
        let relativeIndex = index % sourceCount
        /// 相对偏移
        let relativeOffSetX = self.contentOffset.y - CGFloat(index) * self.frame.size.height
        /// scale
        var scale = relativeOffSetX / self.frame.size.height
        
        var toIndex: Int!
        var fromIndex: Int!
        
        if isTopBottom {
            fromIndex = relativeIndex
            if scale == 0 {
                fromIndex -= 1
                scale = 1
            }
            toIndex = fromIndex + 1
            if toIndex >= sourceCount {
                toIndex -= sourceCount
            }
        } else {
            fromIndex = relativeIndex - 1
            toIndex = relativeIndex
            scale = 1 - scale
        }
        fromIndex = correct(index: fromIndex)
        toIndex = correct(index: toIndex)
        self.carouseDelegate?.carouseView(self, from: fromIndex, to: toIndex, scale: scale)
        lastTimeOffset = self.contentOffset.y
    }
    
    /// 矫正index
    fileprivate func correct(index: Int) -> Int {
        if index < 0 {
            return index + sourceCount
        }
        if index >= sourceCount {
            return index - sourceCount
        }
        return index
    }
}

extension EasyCarouseView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.changePageIndex()
        self.changeScale()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if isAuto {
            setupTimer()
        }
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if isAuto {
            invalidateTimer()
        }
    }
}

/// MARK: CollectionDelegate/DataSource/DelegateFlowLayout
extension EasyCarouseView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = self.pageIndex(by: indexPath)
        self.carouseDelegate?.carouseView(self, selectedAt: index)
    }
}

extension EasyCarouseView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalItemsCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = self.pageIndex(by: indexPath)
        let cell = self.carouseDataSource?.carouseView(self, cellForItemAt: indexPath, itemIndex: index)
        return cell ?? UICollectionViewCell()
    }
}

