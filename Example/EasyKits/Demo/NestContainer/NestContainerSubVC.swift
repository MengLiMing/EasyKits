//
//  NestContainerSubVC.swift
//  EasyKits_Example
//
//  Created by Ming on 2021/4/29.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import EasyKits

extension NestContainerSubVC: EasyPagingContainerItem { }
class NestContainerSubVC: UIViewController {
    let segmentView = EasySegmentedView(frame: .zero).then {
        $0.edgeInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        $0.itemSpacing = 10
        $0.indicatorView = EasySegmentedIndicatorLineView(frame: .zero).then {
            $0.backgroundColor = .red
        }
        $0.tapAnimation = .normal(0.1)
    }
    
    fileprivate lazy var listModel: [EasySegmentedTextModel] = {
        return createListModel(list: ["精选", "日用百货", "话费充值", "食品", "母婴", "女装", "男装", "生活服务", "家电", "数码", "服饰", "护肤彩妆", "品质母婴", "汇吃美食"])
    }()
    
    var stopAt: ((SyncInnerScroll?) -> Void)?
    let containerView = EasyPagingContainerView(frame: .zero)
    override func viewDidLoad() {
        super.viewDidLoad()
     
        segmentView.delegate = self
        segmentView.dataSource = self
        
        containerView.delegate = self
        containerView.dataSource = self
        
        [segmentView, containerView].forEach { view.addSubview($0) }
        segmentView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(0)
            if #available(iOS 11.0, *) {
                maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            } else {
                maker.top.equalTo(self.topLayoutGuide.snp.bottom)
            }
            maker.height.equalTo(40)
        }

        containerView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(0)
            maker.top.equalTo(self.segmentView.snp.bottom)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            } else {
                maker.bottom.equalTo(self.bottomLayoutGuide.snp.top)
            }
        }
    }
    
    func createListModel(list: [String]) -> [EasySegmentedTextModel] {
        list.map { text in
            var itemWidth = NSString(string: text).boundingRect(with: CGSize(width: CGFloat.infinity, height: CGFloat.infinity), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 13)], context: nil).size.width
            itemWidth = CGFloat(ceil(itemWidth))

            let model = EasySegmentedTextModel(text: text, normalColor: .black, selectColor: .red, font: UIFont.systemFont(ofSize: 13))
            model.contentWidth = itemWidth
            model.dynamicWidth = itemWidth*16/13
            model.maxZoomScale = 16/13
            model.maxStrokeWidth = -5
            return model
        }
    }
}

extension NestContainerSubVC: EasySegmentedViewDelegate, EasySegmentedViewDataSource {
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


extension NestContainerSubVC: EasyPagingContainerViewDelegate, EasyPagingContainerViewDataSource {
    func containerViewDidScroll(containerView: EasyPagingContainerView) {
        segmentView.scroll(by: containerView.scrollView)
    }
    
    func containerView(_ containerView: EasyPagingContainerView, itemAt index: Int) -> EasyPagingContainerItem? {
        NestContainerItemVC().then {
            $0.title = (self.title ?? "") + "-" + listModel[index].text
        }
    }
    
    func numberOfItems(in containerView: EasyPagingContainerView) -> Int {
        listModel.count
    }
    
    func containerView(_ containerView: EasyPagingContainerView, from fromIndex: Int, to toIndex: Int, percent: CGFloat) {
        containerView.addSubView(at: toIndex)
    }
    
    func containerView(_ containerView: EasyPagingContainerView, item: EasyPagingContainerItem, stopAt index: Int) {
        guard let inner = item as? SyncScrollInnerProvider else { return }
        stopAt?(inner.syncInner)
    }
}
