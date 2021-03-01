//
//  EasySegmentedView.swift
//  EasyKits
//
//  Created by 孟利明 on 2021/2/25.
//

import UIKit

public protocol EasySegmentedViewDelegate: NSObjectProtocol {
    //点击
    func segmentedView(_ segmentedView: EasySegmentedView, didSelectedAtIndex index: Int, isSame: Bool)
}


public protocol EasySegmentedViewDataSource: NSObjectProtocol {
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

/// 分段切换 风格
enum EasySegmentedSwitchStyle {
    /// 外部scrollView滚动 外部滚动中不能点击
    case scroll
    /// 点击切换 点击不响应滚动逻辑
    case tap
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
    /// 点击切换是否需要动画 默认为 true
    public var isTapNeedAnimation: Bool = true
    /// 点击动画的动画时间 isNeedSwitchAnimation 为true时生效
    public var tapAnimationDuration: TimeInterval = 0.2
    /// 当前下标
    public private(set) var selectedIndex: Int = 0
    
    /// 当前指示器
    public var indicatorView: EasySegmentedIndicatorBaseView? {
        willSet {
            indicatorView?.removeFromSuperview()
        }
        didSet {
            guard let indicatorView = indicatorView else {
                return
            }
            collectionView.addSubview(indicatorView)
            indicatorView.selected(from: nil, to: self.itemFrame(selectedIndex), animation: false)
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
    
    fileprivate lazy var progressMaker: EasySegmentedProgressMaker = {
       return EasySegmentedProgressMaker(duration: tapAnimationDuration)
    }()
    
    
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
        
        let frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: floor(bounds.size.height))
        if isFirstLayout {
            isFirstLayout = false
            collectionView.frame = frame
            itemModels = self.dataSource?.segmentedItemModels(for: self) ?? []
            dataSource?.registerCellClass(in: self)
            self.changeSelectedIndex(to: defaultSelectedIndex)
            self.reloadData()
        } else {
            if collectionView.frame != frame {
                collectionView.frame = frame
                collectionView.collectionViewLayout.invalidateLayout()
                collectionView.reloadData()
            }
        }
    }
    
    // MARK: Public Method
    public func reloadData() {
        itemModels = self.dataSource?.segmentedItemModels(for: self) ?? []
        dataSource?.registerCellClass(in: self)
        changeSelectedIndex(to: selectedIndex)
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.reloadData()
    }
    
    //外部scrollView控制
    public func scroll(by scrollView: UIScrollView) {
        guard itemModels.count > 0 else {
            return
        }
        //最大下标
        let maxIndex = itemModels.count - 1
        //最大偏移
        let maxOffsetX = (CGFloat(maxIndex) * scrollView.frame.width)
        //修正contentOffsetx
        let contentOffsetX = max(0, min(scrollView.contentOffset.x, maxOffsetX))
        
        /// 点击不走 滑动切换
        if self.switchStyle != .tap {
            /// 点击之后 立即滑动 需要将点击动画停止
            self.progressMaker.stop()
            
            self.switchStyle = .scroll
                        
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
                if self.selectedIndex == 0 { return }
                toIndex = max(0, currentIndex - 1)
            } else if percent > 0 && percent < 1 {//滑动向右
                if self.selectedIndex == maxIndex { return }
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
    
    /// 改变选中下标
    /// - Parameter targetIndex: 目标下标
    func changeSelectedIndex(to targetIndex: Int, animation: Bool = false) {
        if animation {
            progressMaker.stop()
            guard selectedIndex != targetIndex else {
                self.switchStyle = nil
                return
            }
            progressMaker.progressHandler = {[weak self] progress in
                guard let `self` = self else {
                    return
                }
                self.changeItem(to: targetIndex, progress: progress)
            }
            progressMaker.completedHandler = {[weak self] in
                guard let `self` = self else {
                    return
                }
                self.switchStyle = nil
                self.selectedIndex = targetIndex
                self.toMiddle(targetIndex, animated: true)
            }
            progressMaker.start()
        } else {
            changeItem(to: targetIndex, progress: 1)
            collectionView.reloadData()
            if self.selectedIndex == targetIndex {
                self.switchStyle = nil
            }
            self.selectedIndex = targetIndex
            toMiddle(targetIndex, animated: false)
        }
        self.indicatorView?.config.sueperContentSize = CGSize(width: self.collectionContentWidth(), height: self.bounds.size.height)
        self.indicatorView?.config.superBounds = self.collectionView.frame
        self.indicatorView?.selected(from: nil, to: self.itemFrame(defaultSelectedIndex), animation: animation)
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
    
    /// 获取item的frame
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
                x += (itemModel.itemWidth + itemSpacing)
            }
            return CGRect(x: x, y: edgeInset.top, width: itemModel.itemWidth, height: collectionView.bounds.size.height - edgeInset.top - edgeInset.bottom)
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
                $0 + $1.itemWidth + itemSpacing
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
        /// 刷新宽度
        collectionView.collectionViewLayout.invalidateLayout()
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
        if let cell = self.dataSource?.segmentedView(self, itemViewAtIndex: indexPath.row) {
            let model = itemModel(indexPath.row)
            cell.refresh(model)
            return cell
        } else {
            return UICollectionViewCell(frame: .zero)
        }
    }
}

extension EasySegmentedView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /// 滑动切换中 不能点击
        if switchStyle == .scroll { return }
        self.switchStyle = .tap
        let targetIndex = indexPath.row
        let oldIndex = self.selectedIndex
        changeSelectedIndex(to: targetIndex, animation: isTapNeedAnimation)
        self.delegate?.segmentedView(self, didSelectedAtIndex: targetIndex, isSame: targetIndex == oldIndex)
    }
}

extension EasySegmentedView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return self.edgeInset
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = itemModel(indexPath.row)
        let itemWidth = model?.itemWidth ?? 0
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
