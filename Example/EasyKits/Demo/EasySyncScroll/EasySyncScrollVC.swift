//
//  EasySyncScrollVC.swift
//  EasyKits_Example
//
//  Created by 孟利明 on 2021/2/22.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import EasyKits
import SnapKit

class EasySyncScrollVC: UIViewController {
    fileprivate lazy var outerScrollView: SyncOuterScrollView = {
        let v = SyncOuterScrollView()
        v.backgroundColor = .red
        if #available(iOS 11.0, *) {
            v.contentInsetAdjustmentBehavior = .never
        }
        v.showsVerticalScrollIndicator = false
        return v
    }()
    
    fileprivate lazy var syncContext: SyncScrollContext = {
        let context = SyncScrollContext(refreshType: .inner)
        context.outerItem = self.outerScrollView
        context.containerView = self.containerView
        return context
    }()
    
    /// 简易的containerView
    fileprivate lazy var containerView: SyncContainerView = {
        let v = SyncContainerView()
        v.customItemHandler = {[weak self] item in
            self?.syncContext.innerItem = item
        }
        return v
    }()
    
    /// 导航栏view - 简单演示
    fileprivate lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    
    /// 总高度
    fileprivate let totalHeight: CGFloat = CGFloat.screenHeight - CGFloat.navBarAndStatusBarHeight
    /// 导航栏高度
    fileprivate let segmentHeight: CGFloat = 60
    /// 横向切换高度
    fileprivate var contentHeight: CGFloat {
        get {
            return totalHeight - segmentHeight - self.syncContext.maxOffsetY
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "\(self.syncContext.refreshType)"

        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "刷新方式", style: .plain, target: self, action: #selector(changeRefreshType)),
            UIBarButtonItem(title: "悬停高度", style: .plain, target: self, action: #selector(changeMaxOffset))]
        
        view.addSubview(outerScrollView)
        outerScrollView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(0)
            maker.top.equalTo(CGFloat.navBarAndStatusBarHeight)
        }
        outerScrollView.addSubview(headerView)
        headerView.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.width.equalTo(CGFloat.screenWidth)
            maker.top.equalTo(self.syncContext.maxOffsetY)
            maker.height.equalTo(60)
        }
        
        outerScrollView.addSubview(containerView)
        containerView.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.top.equalTo(self.headerView.snp.bottom)
            maker.width.equalTo(CGFloat.screenWidth)
            maker.height.equalTo(self.totalHeight - self.segmentHeight)
        }
        self.changeMaxOffset()
        
        /// 设置初始innerItem
        self.containerView.customItemChange()
    }
    
    @objc fileprivate func changeRefreshType() {
        if self.syncContext.refreshType == .inner {
            self.syncContext.refreshType = .outer
        } else {
            self.syncContext.refreshType = .inner
        }
        self.title = "\(self.syncContext.refreshType)"
    }
    
    @objc fileprivate func changeMaxOffset() {
        let maxOffsetY = CGFloat(200 + 10 * (arc4random() % 10))
        self.syncContext.maxOffsetY = maxOffsetY
        /// 因为外部是使用的UIScrollView，所以改变头部高度 需要重新设置高度
        /// 实际开放中 如果头部高度不改变使用UIScrollView作为外部底层即可
        /// 如果头部高度会变化，如电商类首页 根据活动不同的投放配置 则可以考虑使用 UITableView、UICollectionView 具体参考EasyListView的电商类首页示例
        self.outerScrollView.contentSize = CGSize(width: .screenWidth, height: totalHeight + maxOffsetY)
        headerView.snp.updateConstraints { (maker) in
            maker.top.equalTo(maxOffsetY)
        }
        self.containerView.contentSize = CGSize(width: 3 * CGFloat.screenWidth, height: contentHeight)
    }
}

/// 外部scrollView
class SyncOuterScrollView: UIScrollView { }
extension SyncOuterScrollView: SyncOuterScrollProtocol, UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.wrapGestureRecognizer(gestureRecognizer, shouldRecognizeSimultaneouslyWith: otherGestureRecognizer)
    }
}


/// 简易的containerView
extension SyncContainerView: SyncScrollContainerProtocol {
    var items: [AnyObject?] {
        return self.containerItems
    }
    
    var currentItem: AnyObject? {
        return containerCurrentItems()
    }

}

class SyncContainerView: UIScrollView, UIScrollViewDelegate {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isPagingEnabled = true
        self.backgroundColor = .white
        self.delegate = self
        self.showsHorizontalScrollIndicator = false
        setSubviews()
    }
    
    var customItemHandler: ((SyncInnerScrollProtocol?) -> Void)?
    
    fileprivate lazy var containerItems: [UIView] = {
        return [SyncInnerScrollView(frame: .zero),
                SyncInnerWebView(),
                SyncInnerTableView(frame: .zero, style: .plain)]
    }()
    
    fileprivate func containerCurrentItems() -> AnyObject? {
        let index = Int(self.contentOffset.x / CGFloat.screenWidth)
        return self.containerItems.element(index)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setSubviews() {
        self.containerItems.enumerated().forEach { (index, item) in
            self.addSubview(item)
            item.snp.makeConstraints { (maker) in
                maker.left.equalTo(CGFloat(index) * CGFloat.screenWidth)
                maker.width.equalTo(CGFloat.screenWidth)
                maker.top.equalTo(0)
                maker.height.equalTo(self.snp.height)
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.customItemChange()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.customItemChange()
    }
    
    func customItemChange() {
        let listView = self.containerCurrentItems() as? SyncInnerScrollProtocol
        self.customItemHandler?(listView)
    }
}
