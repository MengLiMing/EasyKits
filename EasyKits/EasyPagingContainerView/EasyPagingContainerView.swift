//
//  EasyPagingContainerView.swift
//  EasyKits
//
//  Created by 孟利明 on 2021/2/25.
//

import UIKit
import SnapKit

// MARK: EasyPagingContainerViewDelegate
public protocol EasyPagingContainerViewDelegate: NSObjectProtocol {
    /// 传递UIScrollView代理
    func containerViewDidScroll(containerView: EasyPagingContainerView)
    
    func containerView(_ containerView: EasyPagingContainerView, fromIndex from: Int, toIndex to: Int, percent: CGFloat)
    
    func containerView(_ containerView: EasyPagingContainerView, item: AnyObject, stopAtIndex index: Int)
    func containerView(_ containerView: EasyPagingContainerView, item: AnyObject, addItemAtIndex index: Int)
    func containerView(_ containerView: EasyPagingContainerView, item: AnyObject, didRemovedAtIndex index: Int)
}

public extension EasyPagingContainerViewDelegate {
    func containerViewDidScroll(containerView: EasyPagingContainerView) { }
    
    func containerView(_ containerView: EasyPagingContainerView, fromIndex from: Int, toIndex to: Int, percent: CGFloat) {}
    func containerView(_ containerView: EasyPagingContainerView, item: AnyObject, stopAtIndex index: Int) { }
    func containerView(_ containerView: EasyPagingContainerView, item: AnyObject, addItemAtIndex index: Int) { }
    func containerView(_ containerView: EasyPagingContainerView, item: AnyObject, didRemovedAtIndex index: Int) { }
}

// MARK: EasyPagingContainerViewDataSource
public protocol EasyPagingContainerViewDataSource: NSObjectProtocol {
    /// 获取页面个数
    func numberOfItems(in containerView: EasyPagingContainerView) -> Int
    
    /// 获取每个Item
    func containerView(_ containerView: EasyPagingContainerView, itemAtIndex index: Int) -> AnyObject?
}

open class EasyPagingContainerView: UIScrollView {
    public weak var containerDelegate: EasyPagingContainerViewDelegate?
    public weak var containerDataSource: EasyPagingContainerViewDataSource?
    
    /// 当前选中下标
    public private(set) var selectedIndex: Int = 0
    
    /// 最大加载数量, 0则按照最大加载处理
    public var maxExistCount: Int = 0
    
    /// 默认下标
    public var defaultSelectedIndex: Int = 0

    
    /// 当前加入的item
    public private(set) var items: [AnyObject?] = []
    /// 按照顺序加入当前的Item下标，超过最大加载数删除
    fileprivate var itemIndexs: [Int] = []
    
    /// 容器view，用以撑开scrollView
    fileprivate lazy var contentView: UIView = {
       let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    // MARK: Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setSubViews()
        pageSetting()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private Method
    fileprivate func setSubViews() {
        self.addSubview(self.contentView)
    }
    
    fileprivate func pageSetting() {
        self.delegate = self
        self.isPagingEnabled = true
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.bounces = false
    }
    
    fileprivate func removeAllItem() {
        for (index, itemOption) in self.items.enumerated() {
            guard let item = itemOption else {
                continue
            }
            if let itemView = item as? UIView {
                itemView.removeFromSuperview()
            } else if let itemVC = item as? UIViewController {
                itemVC.view.removeFromSuperview()
                itemVC.removeFromParent()
            }
            self.containerDelegate?.containerView(self, item: item, didRemovedAtIndex: index)
        }
        
        self.items = []
        self.itemIndexs = []
    }
    
    /// 删除最早加入的
    fileprivate func removeFirstAppendItem() {
        if self.maxExistCount == 0 { return }
        if self.itemIndexs.count <= self.maxExistCount {
            return
        }
        
        if let firstIndex = self.itemIndexs.first {
            self.removeItem(at: firstIndex)
        }
        
        self.itemIndexs.removeFirst()
    }
    
    /// 删除离当前位置最远的
    fileprivate func removeFarthestItem() {
        if self.maxExistCount == 0 { return }
        if self.itemIndexs.count <= self.maxExistCount {
            return
        }
        
        var farstItemIndex: Int?
        var index: Int?
        var maxDistance = 0
        for (i, itemIndex) in self.itemIndexs.enumerated() {
            var distance = itemIndex - self.selectedIndex
            distance = distance > 0 ? distance : -distance
            if distance > maxDistance {
                maxDistance = distance
                farstItemIndex = itemIndex
                index = i
            }
        }

        if let index = index,
            let farstItemIndex = farstItemIndex {
            
            self.removeItem(at: farstItemIndex)
            self.itemIndexs.remove(at: index)
        }
    }
    
    fileprivate func removeItem(at index: Int) {
        if self.items.count <= index || index < 0 { return }
        
        guard let item = self.items[index] else {
            return
        }
        
        if let itemView = item as? UIView {
            itemView.removeFromSuperview()
        } else if let itemVC = item as? UIViewController {
            itemVC.view.removeFromSuperview()
            itemVC.removeFromParent()
        }
        
        self.containerDelegate?.containerView(self, item: item, didRemovedAtIndex: index)
        self.items[index] = nil
        
    }
    
    // MARK: Public Method
    public func reloadData() {
        //获取页面个数
        guard let count = self.containerDataSource?.numberOfItems(in: self) else {
            return
        }
        
        self.superview?.layoutIfNeeded()
        
        self.contentView.snp.remakeConstraints { (maker) in
            maker.edges.equalToSuperview()
            maker.height.equalTo(self.snp.height)
            maker.width.equalTo(self.frame.width * CGFloat(count))
        }

        if count <= 0 { return }
        //重置
        self.reSetData()
        
        //初始化数组
        self.items = Array<AnyObject?>(repeating: nil, count: count)
        self.setContentOffset(CGPoint(x: self.frame.width * CGFloat(self.defaultSelectedIndex), y: 0), animated: false)
        self.selectedIndex = defaultSelectedIndex
    }
    
    /// 重新初始化
    public func reSetData() {
        self.selectedIndex = 0
        self.removeAllItem()
    }
    
    public func addAllSubViews() {
        //获取页面个数
        guard let count = self.containerDataSource?.numberOfItems(in: self) else {
            return
        }
        
        for index in 0..<count {
            self.addSubView(atIndex: index)
        }
    }
    
    public func item(atIndex index: Int) -> AnyObject? {
        if self.items.count > index && index >= 0 {
            return self.items[index]
        }
        return nil
    }
    
    public func currentItem() -> AnyObject? {
        return self.item(atIndex: self.selectedIndex)
    }
    
    public func index(forItem item: AnyObject?) -> Int? {
        guard let item = item else {
            return nil
        }
        
        return self.items.firstIndex { item.isEqual($0) }
    }
    
    public func addSubView(atIndex index: Int) {
        if items.count <= index { return }
        
        if let _ = items[index] {
            return
        }
        
        let singleWidth = self.frame.width
        
        guard let item = self.containerDataSource?.containerView(self, itemAtIndex: index) else {
            return
        }
        
        if let itemView = item as? UIView {
            self.contentView.addSubview(itemView)
            itemView.snp.makeConstraints { (maker) in
                maker.top.bottom.equalTo(self.contentView)
                maker.width.equalTo(singleWidth)
                maker.left.equalTo(singleWidth * CGFloat(index))
            }
        } else if let itemVC = item as? UIViewController {
            self.contentView.addSubview(itemVC.view)
            itemVC.view.snp.makeConstraints { (maker) in
                maker.top.bottom.equalTo(self.contentView)
                maker.width.equalTo(singleWidth)
                maker.left.equalTo(singleWidth * CGFloat(index))
            }
        }
        
        //添加item
        self.items[index] = item
        self.itemIndexs.append(index)
        
        self.containerDelegate?.containerView(self, item: item, addItemAtIndex: index)

        /// 删除item
        self.removeFarthestItem()
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
        self.selectedIndex = index
        self.addSubView(atIndex: index)
        if let item = items[index] {
            self.containerDelegate?.containerView(self, item: item, stopAtIndex: index)
        }
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
        self.containerDelegate?.containerView(self, fromIndex: selectedIndex, toIndex: toIndex, percent: percent)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.addSubview(at: scrollView.contentOffset)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.addSubview(at: scrollView.contentOffset)
    }
}
