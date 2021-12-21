//
//  EasySegmentedView.swift
//  EasyKits
//
//  Created by 孟利明 on 2021/2/25.
//

import UIKit

public protocol EasySegmentedViewDelegate: AnyObject {
    //点击
    func segmentedView(_ segmentedView: EasySegmentedView, didSelectedAtIndex index: Int, isSame: Bool)
}


public protocol EasySegmentedViewDataSource: AnyObject {
    /// 提供cell的注册
    /// - Parameter segmentedView: EasySegmentedView
    func registerCellClass(in segmentedView: EasySegmentedView)
    /// 返回当前cell的所需数据
    /// - Parameters:
    ///   - segmentedView: EasySegmentedView
    ///   - index: 下标
    func segmentedItemModels(for segmentedView: EasySegmentedView) -> [EasySegmentBaseItemModel]
    
    /// 返回当前cell
    /// - Parameters:
    ///   - segmentedView: EasySegmentedView
    ///   - index: 下标
    func segmentedView(_ segmentedView: EasySegmentedView, itemViewAtIndex index: Int) -> EasySegmentedBaseCell
}

/// 当前切换的方式
enum EasySegmentedSwitchStyle {
    /// 外部scrollView滚动 外部滚动中不能点击
    case scroll
    /// 点击切换 点击不响应滚动逻辑
    case tap
}

public enum EasySegmentedTapAnimation {
    /// 默认动画 time为0 不支持动画
    case normal(TimeInterval)
    /// 点击无动画 依赖其他scrollView滚动
    case byScroll
    
    public static let normal = EasySegmentedTapAnimation.normal(0.2)
    
    public static let none = EasySegmentedTapAnimation.normal(0)
    
    public var duration: TimeInterval {
        switch self {
        case .normal(let duration):
            return duration
        case .byScroll:
            return 0
        }
    }
}

public class EasySegmentedView: UIView {
    
    public weak var dataSource: EasySegmentedViewDataSource?
    public weak var delegate: EasySegmentedViewDelegate?
    
    /// 默认选中
    public var defaultSelectedIndex: Int = 0
    /// 间距
    public var itemSpacing: CGFloat = 0
    /// 内边距
    public var edgeInset: UIEdgeInsets = .zero
    /// 点击切换的动画
    public var tapAnimation: EasySegmentedTapAnimation = .normal
    /// 当前下标
    public private(set) var selectedIndex: Int = 0
    
    /// 当前指示器
    public var indicatorView: EasySegmentedIndicatorBaseView? {
        didSet {
            oldValue?.removeFromSuperview()
            guard let indicatorView = indicatorView else {
                return
            }
            collectionView.addSubview(indicatorView)
        }
    }
    
    public var bounces: Bool {
        set {
            collectionView.bounces = newValue
        }
        get {
            collectionView.bounces
        }
    }
    
    public private(set) lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        view.scrollsToTop = false
        view.dataSource = self
        view.delegate = self
        if #available(iOS 11.0, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        return view
    }()
    
    fileprivate lazy var progressMaker: EasySegmentedProgressMaker = .init()
    
    fileprivate var isFirstLayout: Bool = true
    /// 数据源 - 保存数据源，避免外部重复计算数据
    fileprivate var itemModels: [EasySegmentBaseItemModel] = []
    /// 当前切换风格
    fileprivate var switchStyle: EasySegmentedSwitchStyle? = nil
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        viewSetting()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewSetting()
    }
    
    fileprivate func viewSetting() {
        addSubview(collectionView)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        configIndicatorView()
        let frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: floor(bounds.size.height))
        if isFirstLayout {
            isFirstLayout = false
            collectionView.frame = frame
            refreshDataSource()
            changeSelectedIndex(to: defaultSelectedIndex)
        } else {
            if collectionView.frame != frame {
                collectionView.frame = frame
                collectionView.collectionViewLayout.invalidateLayout()
                collectionView.reloadData()
            }
            changeSelectedIndex(to: selectedIndex)
        }
    }
    
    fileprivate func refreshDataSource() {
        itemModels = self.dataSource?.segmentedItemModels(for: self) ?? []
        dataSource?.registerCellClass(in: self)
    }
    
    // MARK: Public Method
    /// 刷新
    /// - Parameter index: 刷新后选中 默认为0
    public func reloadData(selectedAt index: Int = 0) {
        refreshDataSource()
        let index = max(0, min(itemModels.count - 1, index))
        UIView.animate(withDuration: 0) {
            self.collectionView.reloadData()
        } completion: { _ in
            self.changeSelectedIndex(to: index)
        }
    }
    
    public func scroll(by scrollView: UIScrollView) {
        guard itemModels.count > 0, (self.switchStyle == nil || self.switchStyle == .scroll) else {
            return
        }
        
        self.progressMaker.stop()
        self.switchStyle = .scroll
        
        //最大下标
        let maxIndex = itemModels.count - 1
        //最大偏移
        let maxOffsetX = (CGFloat(maxIndex) * scrollView.frame.width)
        //修正contentOffsetx
        let contentOffsetX = max(0, min(scrollView.contentOffset.x, maxOffsetX))
        
        //过滤前后继续滑动
        if (self.selectedIndex == 0 && contentOffsetX == 0) || (self.selectedIndex == maxIndex && contentOffsetX == maxOffsetX) {
            self.switchStyle = nil
            return
        }
        
        /// 当前下标
        let currentIndex = self.selectedIndex
        
        //百分比
        var percent = (contentOffsetX - CGFloat(currentIndex) * scrollView.frame.width)/scrollView.frame.width
        
        var toIndex: Int = currentIndex
        
        if percent < 0 && percent > -1 {//滑动向左
            if currentIndex == 0 { return }
            toIndex = max(0, currentIndex - 1)
        } else if percent > 0 && percent < 1 {//滑动向右
            if currentIndex == maxIndex { return }
            toIndex = min(maxIndex, currentIndex + 1)
        } else {//直接设置contentOffset 或 切换边缘 -2 -1 0 1 2
            toIndex = min(maxIndex, currentIndex + Int(percent))
            percent = percent < 0 ? -1 : 1
            self.selectedIndex = toIndex
        }
        
        if currentIndex != toIndex {
            refreshItemModel(at: currentIndex, percent: 1 - abs(percent))
            refreshItemModel(at: toIndex, percent: abs(percent))
            
            /// 跟随外部置中
            let selectedFrame = itemFrame(currentIndex)
            let toFrame = itemFrame(toIndex)
            let seletectMidx = selectedFrame.midX
            let toMidx = toFrame.midX
            let targetOffset = seletectMidx + (toMidx - seletectMidx) * abs(percent)
            self.indicatorView?.scroll(from: selectedFrame, to: toFrame, progress: abs(percent))
            toMiddle(targetOffset, animated: false)
        }
        
        let index = Int(scrollView.contentOffset.x / scrollView.frame.width)
        if contentOffsetX == (CGFloat(index) * scrollView.frame.width) {
            //滑动结束，重置
            self.switchStyle = nil
        }
    }
}

// MARK: PUBLIC METHOD
public extension EasySegmentedView {
    /// 注册cell
    /// - Parameter name: EasySegmentedBaseCell子类.self
    func register<T: EasySegmentedBaseCell>(cellWithClass name: T.Type) {
        collectionView.register(T.self, forCellWithReuseIdentifier: String(describing: name))
    }
    
    /// 获取重用cell
    /// - Parameters:
    ///   - name: EasySegmentedBaseCell子类.self
    ///   - index: 下标
    /// - Returns: EasySegmentedBaseCell
    func dequeueReusableCell<T: EasySegmentedBaseCell>(withClass name: T.Type, at index: Int) -> EasySegmentedBaseCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: name), for: IndexPath(row: index, section: 0)) as? T else {
            fatalError("请检查是否注册:\(String(describing: name))")
        }
        return cell
    }
    
    func changeSelectedIndex(to targetIndex: Int) {
        configIndicatorView()
        changeItem(to: targetIndex, progress: 1)
        collectionView.reloadData()
        self.selectedIndex = targetIndex
        toMiddle(targetIndex, animated: self.switchStyle == .tap)
        self.switchStyle = nil
        self.indicatorView?.selected(to: self.itemFrame(targetIndex), animation: false)
    }
    
    fileprivate func tapAnimation(to targetIndex: Int, duration: TimeInterval) {
        guard duration > 0 else {
            changeSelectedIndex(to: targetIndex)
            return
        }
        progressMaker.stop()
        guard selectedIndex != targetIndex else {
            self.switchStyle = nil
            return
        }
        configIndicatorView()
        progressMaker.duration = duration
        let currentFrame = self.itemFrame(selectedIndex)
        let whenSelectedFrame = self.itemFrame(whenSelectedAt: targetIndex)
        progressMaker.progressHandler = {[weak self] progress in
            self?.changeItem(to: targetIndex, progress: progress)
            self?.indicatorView?.scroll(from: currentFrame, to: whenSelectedFrame, progress: progress)
        }
        progressMaker.completedHandler = {[weak self] in
            self?.switchStyle = nil
            self?.selectedIndex = targetIndex
        }
        progressMaker.start()
        self.toMiddle(whenSelectedFrame.midX, animated: true)
    }
    
    fileprivate func configIndicatorView() {
        guard let indicatorView = indicatorView else {
            return
        }
        indicatorView.superBounds = self.collectionView.frame
        indicatorView.isHidden = itemModels.count == 0
    }
    
    fileprivate func changeItem(to targetIndex: Int, progress: CGFloat) {
        refreshItemModel(at: targetIndex, percent: progress)
        if selectedIndex != targetIndex {
            refreshItemModel(at: selectedIndex, percent: 1 - progress)
        }
    }
}

fileprivate extension EasySegmentedView {
    /// 将目标下标置中
    /// - Parameters:
    ///   - index: 目标下标
    ///   - animated: 是否有动画
    func toMiddle(_ index: Int?, animated: Bool) {
        guard let index = index else {
            return
        }
        let itemFrame = self.itemFrame(index)
        toMiddle(itemFrame.midX, animated: animated)
    }
    
    
    /// 将目标偏移置中
    /// - Parameters:
    ///   - targetOffset: 当前的偏移
    ///   - animated: 是否有动画
    func toMiddle(_ targetOffset: CGFloat, animated: Bool) {
        if collectionContentWidth() > self.collectionView.frame.width {
            let centerOffset = targetOffset - self.collectionView.frame.width * 0.5
            
            let minOffset: CGFloat = 0
            let maxOffset = collectionContentWidth() - self.collectionView.frame.width
            let needOffset = min(max(minOffset, centerOffset), maxOffset)
            self.collectionView.setContentOffset(CGPoint(x: needOffset, y: 0), animated: animated)
        }
    }
    
    func itemModel(_ index: Int) -> EasySegmentBaseItemModel? {
        if itemModels.count > index && index >= 0 {
            return itemModels[index]
        }
        return nil
    }
    
    /// 获取当前item
    func item(_ index: Int?) -> EasySegmentedBaseCell? {
        guard let index = index else {
            return nil
        }
        return self.collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? EasySegmentedBaseCell
    }
    
    /// 获取item的frame - 实时
    func itemFrame(_ index: Int?) -> CGRect {
        guard let index = index else {
            return .zero
        }
        if let itemView = item(index) {
            return itemView.frame
        } else if let itemModel = self.itemModel(index) {
            /// 如果cell不在可视区域内，则需要计算item的frame
            var x = edgeInset.left
            for (itemIndex, itemModel) in itemModels.enumerated() where itemIndex < index {
                x += (itemModel.realWidth + itemSpacing)
            }
            return CGRect(x: x, y: edgeInset.top, width: itemModel.realWidth, height: collectionView.bounds.size.height - edgeInset.top - edgeInset.bottom)
        }
        return .zero
    }
    
    /// 下标被选中时 item的frame
    func itemFrame(whenSelectedAt index: Int) -> CGRect {
        if let itemModel = self.itemModel(index) {
            var x = edgeInset.left
            for (itemIndex, itemModel) in itemModels.enumerated() where itemIndex < index {
                x += (itemModel.startWidth + itemSpacing)
            }
            return CGRect(x: x, y: edgeInset.top, width: itemModel.endWidth, height: collectionView.bounds.size.height - edgeInset.top - edgeInset.bottom)
        }
        return .zero
    }
    
    /// 获取contentSize
    func collectionContentWidth() -> CGFloat {
        //某些情况下获取不到contentSize的宽度 - 初始化页面时
        if self.collectionView.contentSize.width > 0 {
            return self.collectionView.contentSize.width
        } else {
            return self.itemModels.reduce(edgeInset.left) {
                $0 + $1.realWidth + itemSpacing
            } - itemSpacing + edgeInset.right
        }
    }
    
    /// 由进度刷新model
    /// - Parameters:
    ///   - index: 下标
    ///   - percent: 进度 0 - 1
    func refreshItemModel(at index: Int, percent: CGFloat) {
        guard let itemModel = self.itemModel(index) else {
            return
        }
        itemModel.percent = percent
        let item = self.item(index)
        item?.refresh(itemModel)
        if itemModel.endWidth != itemModel.startWidth {
            /// 刷新宽度
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
}


extension EasySegmentedView: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemModels.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.dataSource?.segmentedView(self, itemViewAtIndex: indexPath.row) else {
            return .init(frame: .zero)
        }
        return cell
    }
}

extension EasySegmentedView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard switchStyle == nil else {
            return
        }

        let oldIndex = self.selectedIndex
        let targetIndex = indexPath.row

        switch tapAnimation {
        case .normal(let duration):
            self.switchStyle = .tap
            tapAnimation(to: targetIndex, duration: duration)
        case .byScroll:
            break
        }
        self.delegate?.segmentedView(self, didSelectedAtIndex: targetIndex, isSame: targetIndex == oldIndex)
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? EasySegmentedBaseCell,
              let itemModel = itemModel(indexPath.row) else {
            return
        }
        cell.refresh(itemModel)
    }
}

extension EasySegmentedView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return self.edgeInset
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = itemModel(indexPath.row)
        let itemWidth = model?.realWidth ?? 0
        let itemHeight = collectionView.bounds.size.height - edgeInset.bottom - edgeInset.top
        return CGSize(width:  itemWidth, height: itemHeight)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
}
