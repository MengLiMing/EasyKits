//
//  NestSyncContainerListVC.swift
//  EasyKits_Example
//
//  Created by Ming on 2021/4/30.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import Then
import EasyKits

/// 以下代码只是简单示例
class OuterContainer: EasyPagingContainerView, SyncScrollContainer {
    func resetContainerItems(_ resetItem: (SyncInnerScroll) -> ()) {
        self.items.values.forEach {
            if let subVC = $0 as? NestContainerSubVC {
                subVC.containerView.items.values.forEach { item in
                    if let itemVC = item as? NestContainerItemVC {
                        resetItem(itemVC.syncInner)
                    }
                }
            }
        }
    }
}
class OuterScrollView: UIScrollView, SyncOuterScroll, UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return wrapGestureRecognizer(gestureRecognizer, shouldRecognizeSimultaneouslyWith: otherGestureRecognizer)
    }
}
class NestSyncContainerListVC: UIViewController {
    let scrollView = OuterScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    let headView = UIView().then {
        $0.backgroundColor = .red
    }
    
    let segmentView = EasySegmentedView(frame: .zero).then {
        $0.indicatorView = EasySegmentedIndicatorLineView(frame: .zero).then {
            $0.backgroundColor = .red
            $0.lineWidth = .fixed(20)
            $0.viewHeight = 4
            $0.layer.cornerRadius = 2
        }
    }
    
    fileprivate lazy var listModel: [EasySegmentedTextModel] = {
        return createListModel(list: ["淘宝", "天猫", "京东", "拼多多", "唯品会"])
    }()
    
    fileprivate let syncContext = SyncScrollContext(refreshType: .outer)
    
    let containerView = OuterContainer(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (maker) in
            maker.leading.trailing.bottom.equalTo(0)
            if #available(iOS 11.0, *) {
                maker.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                maker.top.equalTo(self.topLayoutGuide.snp.bottom)
            }
        }
        
        syncContext.maxOffsetY = 300
        syncContext.outerItem = scrollView
        syncContext.containerView = containerView
        
        segmentView.delegate = self
        segmentView.dataSource = self
        
        containerView.delegate = self
        containerView.dataSource = self

        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        scrollView.contentSize = CGSize(width: UIScreen.screenWidth, height: UIScreen.screenHeight - UIScreen.navigationHeight + 300)
        [headView, segmentView, containerView].forEach { scrollView.addSubview($0) }
        headView.snp.makeConstraints { (maker) in
            maker.leading.top.equalTo(0)
            maker.width.equalToSuperview()
            maker.height.equalTo(300)
        }
        
        segmentView.snp.makeConstraints { (maker) in
            maker.leading.width.equalTo(self.headView)
            maker.top.equalTo(self.headView.snp.bottom)
            maker.height.equalTo(50)
        }
        
        containerView.snp.makeConstraints { (maker) in
            maker.leading.width.equalTo(self.headView)
            maker.top.equalTo(self.segmentView.snp.bottom)
            maker.height.equalTo(UIScreen.screenHeight - UIScreen.navigationHeight - 50)
        }
        
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "刷新方式", style: .plain, target: self, action: #selector(changeRefreshType)),
            UIBarButtonItem(title: "悬停高度", style: .plain, target: self, action: #selector(changeMaxOffset))]
    }
    
    
    func createListModel(list: [String]) -> [EasySegmentedTextModel] {
        list.map { text in
            let model = EasySegmentedTextModel(text: text, normalColor: .black, selectColor: .red, font: UIFont.systemFont(ofSize: 13))
            model.contentWidth = UIScreen.screenWidth / CGFloat(list.count)
            model.maxZoomScale = 16/13
            model.maxStrokeWidth = -5
            return model
        }
    }
    
    @objc fileprivate func changeRefreshType() {
        if syncContext.refreshType == .inner {
            syncContext.refreshType = .outer
        } else {
            syncContext.refreshType = .inner
        }
        self.title = "\(syncContext.refreshType)"
    }
    
    @objc fileprivate func changeMaxOffset() {
        let height = CGFloat(100 + arc4random() % 200)
        headView.snp.updateConstraints { (maker) in
            maker.height.equalTo(height)
        }
        UIView.animate(withDuration: 0.3) {
            self.scrollView.layoutIfNeeded()
        } completion: { _ in
            self.scrollView.contentSize = CGSize(width: UIScreen.screenWidth, height: UIScreen.screenHeight - UIScreen.navigationHeight + height)
            self.syncContext.maxOffsetY = height
        }
    }
}

extension NestSyncContainerListVC: EasySegmentedViewDelegate, EasySegmentedViewDataSource {
    func registerCellClass(in segmentedView: EasySegmentedView) {
        segmentedView.register(cellWithClass: EasySegmentedTextCell.self)
    }
    
    func segmentedItemModels(for segmentedView: EasySegmentedView) -> [EasySegmentBaseItemModel] {
        listModel
    }
    
    func segmentedView(_ segmentedView: EasySegmentedView, itemViewAtIndex index: Int) -> EasySegmentedBaseCell {
        let cell = segmentedView.dequeueReusableCell(withClass: EasySegmentedTextCell.self, at: index)
        return cell
    }
    
    func segmentedView(_ segmentedView: EasySegmentedView, didSelectedAtIndex index: Int, isSame: Bool) {
        if !isSame {
            containerView.scroll(toIndex: index)
        }
    }
}


extension NestSyncContainerListVC: EasyPagingContainerViewDelegate, EasyPagingContainerViewDataSource {
    func containerViewDidScroll(containerView: EasyPagingContainerView) {
        segmentView.scroll(by: containerView.scrollView)
    }
    
    func containerView(_ containerView: EasyPagingContainerView, itemAt index: Int) -> EasyPagingContainerItem? {
        NestContainerSubVC().then {
            $0.title = listModel[index].text
            $0.stopAt = { inner in
                self.syncContext.innerItem = inner
            }
        }
    }
    
    func numberOfItems(in containerView: EasyPagingContainerView) -> Int {
        listModel.count
    }
    
    func containerView(_ containerView: EasyPagingContainerView, from fromIndex: Int, to toIndex: Int, percent: CGFloat) {
        containerView.addSubView(at: toIndex)
    }
    
    func containerView(_ containerView: EasyPagingContainerView, item: EasyPagingContainerItem, stopAt index: Int) {
        guard let subVC = item as? NestContainerSubVC, let subItem = subVC.containerView.currentItem() as? SyncScrollInnerProvider else {
            return
        }
        syncContext.innerItem = subItem.syncInner
    }
}
