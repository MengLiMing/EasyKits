//
//  EasyPagingContainerView.swift
//  EasyKits
//
//  Created by 孟利明 on 2021/2/25.
//

import UIKit

// MARK: EasyPagingContainerViewDelegate
public protocol EasyPagingContainerViewDelegate: class {
    
    /// 滑动回调
    /// - Parameter containerView: 配合EasySegmentedView使用简单
    func containerViewDidScroll(containerView: EasyPagingContainerView)
    
    /// 切换回调
    /// - Parameters:
    ///   - containerView: EasyPagingContainerView
    ///   - from: from下标
    ///   - to: to下标
    ///   - percent: 滑动进度(可以根据进度，自行调用addSubview，选择添加view的时机，默认是滑动停止)
    func containerView(_ containerView: EasyPagingContainerView, from fromIndex: Int, to toIndex: Int, percent: CGFloat)
    
    
    /// 停止回调
    /// - Parameters:
    ///   - containerView: EasyPagingContainerView
    ///   - item: 停止时的Item
    ///   - index: 停止的下标
    func containerView(_ containerView: EasyPagingContainerView, item: EasyPagingContainerItem, stopAt index: Int)
    
    /// 视图添加回调
    /// - Parameters:
    ///   - containerView: EasyPagingContainerView
    ///   - item: 添加的试图
    ///   - index: 添加的下标
    func containerView(_ containerView: EasyPagingContainerView, item: EasyPagingContainerItem, addAt index: Int)
    
    
    /// 删除试图回调
    /// - Parameters:
    ///   - containerView: EasyPagingContainerView
    ///   - item: 删除的item
    ///   - index: 删除的下标
    func containerView(_ containerView: EasyPagingContainerView, item: EasyPagingContainerItem, removedAt index: Int)
}

public extension EasyPagingContainerViewDelegate {
    func containerViewDidScroll(containerView: EasyPagingContainerView) { }
    func containerView(_ containerView: EasyPagingContainerView, from fromIndex: Int, to toIndex: Int, percent: CGFloat) {}
    func containerView(_ containerView: EasyPagingContainerView, item: EasyPagingContainerItem, stopAt index: Int) { }
    func containerView(_ containerView: EasyPagingContainerView, item: EasyPagingContainerItem, addAt index: Int) { }
    func containerView(_ containerView: EasyPagingContainerView, item: EasyPagingContainerItem, removedAt index: Int) { }
}

// MARK: EasyPagingContainerViewDataSource
public protocol EasyPagingContainerViewDataSource: class {
    /// 数据源数量
    /// - Parameter containerView: EasyPagingContainerView
    func numberOfItems(in containerView: EasyPagingContainerView) -> Int

    /// 获取添加的item
    /// - Parameters:
    ///   - containerView: EasyPagingContainerView
    ///   - index: 需要添加的下标
    func containerView(_ containerView: EasyPagingContainerView, itemAt index: Int) -> EasyPagingContainerItem?
        
    /// 需要删除时，判断是否需要删除(如超过最大加载数量，而有些页面需要常驻)
    /// - Parameters:
    ///   - containerView: EasyPagingContainerView
    ///   - index: 将要删除的下标
    func itemWillRemove(of containerView: EasyPagingContainerView, at index: Int) -> Bool
}

public extension EasyPagingContainerViewDataSource {
    func itemWillRemove(of containerView: EasyPagingContainerView, at index: Int) -> Bool {
        return true
    }
}

public protocol EasyPagingContainerItem {
    var itemView: UIView { get }
    var itemViewController: UIViewController? { get }
}

public extension EasyPagingContainerItem where Self: UIView {
    var itemView: UIView {
        self
    }
    var itemViewController: UIViewController? {
        nil
    }
}

public extension EasyPagingContainerItem where Self: UIViewController {
    var itemView: UIView {
        self.view
    }
    var itemViewController: UIViewController? {
        self
    }
}

public class EasyPagingContainerView: UIScrollView {
    /// 删除
    public enum RemoveStrategy {
        /// 删除最早加入的
        case earliest
        /// 删除距离当前选中最远的
        case farthest
    }
    
    public weak var containerDelegate: EasyPagingContainerViewDelegate?
    public weak var containerDataSource: EasyPagingContainerViewDataSource?
    /// 默认下标
    public var defaultSelectedIndex: Int = 0
    /// 当前选中下标
    public private(set) var selectedIndex: Int = 0
    /// 最大加载数量, 0则按照最大加载处理
    public var maxExistCount: Int = 0
    /// 当前加入的item
    public private(set) var items: [Int: EasyPagingContainerItem] = [:]
    /// 删除策略
    public var removeStrategy: RemoveStrategy = .farthest
    
    fileprivate var itemIndexs: [Int] = []
    fileprivate var isFirstLayout: Bool = true

    // MARK: Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        config()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private Method
    fileprivate func config() {
        self.delegate = self
        self.isPagingEnabled = true
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.bounces = false
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()

        guard let dataSource = self.containerDataSource else {
            return
        }
        let itemCount = dataSource.numberOfItems(in: self)
        let targetSize = CGSize(width: CGFloat(itemCount) * bounds.size.width, height: bounds.size.height)
        if targetSize == contentSize {
            return
        }
        contentSize = targetSize
        if isFirstLayout {
            isFirstLayout = false
            scroll(toIndex: defaultSelectedIndex, animated: false)
        } else {
            resetItems()
            scroll(toIndex: selectedIndex, animated: false)
        }
    }
    
    // MARK: Public Method
    /// 刷新
    /// - Parameter index: 刷新后选中 默认为0
    public func reloadData(selectedAt index: Int = 0) {
        self.removeAllItem()
        self.scroll(toIndex: index, animated: false)
    }
    
    public func item(atIndex index: Int) -> EasyPagingContainerItem? {
        return self.items[index]
    }
    
    public func currentItem() -> EasyPagingContainerItem? {
        return self.item(atIndex: self.selectedIndex)
    }
    
    public func addSubView(at index: Int) {
        if let item = items[index] {
            self.containerDelegate?.containerView(self, item: item, stopAt: index)
            return
        }
        guard let item = self.containerDataSource?.containerView(self, itemAt: index) else {
            return
        }
        
        self.addSubview(item.itemView)
        item.itemView.frame = CGRect(x: CGFloat(index) * bounds.size.width, y: 0, width: bounds.size.width, height: bounds.size.height)
  
        self.items[index] = item
        self.itemIndexs.append(index)
        
        self.containerDelegate?.containerView(self, item: item, addAt: index)
        self.containerDelegate?.containerView(self, item: item, stopAt: index)

    }
    
    public func scroll(toIndex index: Int, animated: Bool = false) {
        guard let count = self.containerDataSource?.numberOfItems(in: self), index < count else {
            return
        }
        let contentOffset_x = CGFloat(index) * self.frame.width
        self.setContentOffset(CGPoint(x: contentOffset_x, y: 0), animated: animated)
    }
    
    // MARK: Override Method
    public override func setContentOffset(_ contentOffset: CGPoint, animated: Bool) {
        super.setContentOffset(contentOffset, animated: animated)
        if !animated {
            self.addSubview(at: contentOffset)
        }
    }
    
    fileprivate func addSubview(at contentOffset: CGPoint) {
        guard self.frame.width > 0 else {
            return
        }
        let index = Int(contentOffset.x / self.frame.width)
        selectedIndex = index
        addSubView(at: index)
        checkToRemove()
    }
}

// MARK: Private Method
fileprivate extension EasyPagingContainerView {
    func resetItems() {
        for index in items.keys {
            guard let item = items[index] else {
                continue
            }
            let itemFrame = CGRect(x: CGFloat(index) * bounds.size.width, y: 0, width: bounds.size.width, height: bounds.size.height)
            item.itemView.frame = itemFrame
        }
    }
    
    /// 删除全部
    func removeAllItem() {
        for index in items.keys {
            guard let item = items[index] else {
                continue
            }
            if let view = item as? UIView {
                view.removeFromSuperview()
            } else if let vc = item as? UIViewController {
                vc.view.removeFromSuperview()
                vc.removeFromParent()
            }
            self.containerDelegate?.containerView(self, item: item, removedAt: index)
        }
        
        self.items = [:]
        self.itemIndexs = []
    }
    
    /// 检测是否需要删除
    func checkToRemove() {
        switch removeStrategy {
        case .earliest:
            removeEarliestItem()
        case .farthest:
            removeFarthestItem()
        }
    }
    
    /// 删除最早加入的
    func removeEarliestItem() {
        guard maxExistCount > 0,
              itemIndexs.count > self.maxExistCount,
              let dataSource = self.containerDataSource else {
            return
        }
        for (index, itemIndex) in itemIndexs.enumerated() where itemIndex != selectedIndex && dataSource.itemWillRemove(of: self, at: itemIndex) {
            removeItem(at: itemIndex)
            itemIndexs.remove(at: index)
            break
        }
    }
    
    /// 删除离当前位置最远的
    func removeFarthestItem() {
        guard maxExistCount > 0,
              itemIndexs.count > self.maxExistCount,
              let dataSource = self.containerDataSource else {
            return
        }
        
        var farstItemIndex: Int?
        var index: Int?
        var maxDistance = 0
        for (i, itemIndex) in self.itemIndexs.enumerated() where itemIndex != selectedIndex && dataSource.itemWillRemove(of: self, at: itemIndex) {
            let distance = abs(itemIndex - self.selectedIndex)
            if distance > maxDistance {
                maxDistance = distance
                farstItemIndex = itemIndex
                index = i
            }
        }

        if let index = index,
            let farstItemIndex = farstItemIndex {
            removeItem(at: farstItemIndex)
            itemIndexs.remove(at: index)
        }
    }
    
    func removeItem(at index: Int) {
        guard let item = self.items[index] else {
            return
        }
        
        item.itemView.removeFromSuperview()
        item.itemViewController?.removeFromParent()

        self.containerDelegate?.containerView(self, item: item, removedAt: index)
        self.items[index] = nil
    }
}

extension EasyPagingContainerView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.containerDelegate?.containerViewDidScroll(containerView: self)

        guard let count = self.containerDataSource?.numberOfItems(in: self), self.contentSize.width > 0 else {
            return
        }
        let maxOffsetX = (CGFloat(count) * scrollView.frame.width)
        let contentOffsetX = max(0, min(scrollView.contentOffset.x, maxOffsetX))

        let selectedIndex = self.selectedIndex
        var percent = (contentOffsetX - CGFloat(selectedIndex) * scrollView.frame.width)/scrollView.frame.width
        var toIndex: Int = selectedIndex

        if percent < 0 && percent > -1 {
            if self.selectedIndex == 0 { return }
            toIndex = max(0, selectedIndex - 1)
        } else if percent > 0 && percent < 1 {
            if self.selectedIndex == count { return }
            toIndex = min(count, selectedIndex + 1)
        } else {
            toIndex = min(count, selectedIndex + Int(percent))
            percent = percent < 0 ? -1 : 1
            self.selectedIndex = toIndex
        }
        self.containerDelegate?.containerView(self, from: selectedIndex, to: toIndex, percent: percent)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.addSubview(at: scrollView.contentOffset)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.addSubview(at: scrollView.contentOffset)
    }
}

