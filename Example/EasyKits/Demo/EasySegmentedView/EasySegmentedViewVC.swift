//
//  EasySegmentedViewVC.swift
//  EasyKits_Example
//
//  Created by 孟利明 on 2021/2/25.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import SnapKit
import EasyKits

class EasySegmentedViewVC: UIViewController {
    fileprivate lazy var segmentedView: EasySegmentedView = {
        let v = EasySegmentedView(frame: .zero)
        v.dataSource = self
        v.delegate = self
        v.edgeInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        v.itemSpacing = 10
        let indicatorView = EasySegmentedIndicatorLineView(frame: .zero)
        indicatorView.backgroundColor = .red
        v.indicatorView = indicatorView
        v.tapAnimationDuration = 0.1
        return v
    }()
    
    fileprivate let list = ["精选", "日用百货", "百货", "百货", "百货", "百货", "百货", "百货", "百货", "日用百货", "百货", "百货", "百货", "百货", "百货", "百货", "百货"]
    
    fileprivate lazy var listModel: [EasySegmentedTextModel] = {
        return list.map { text in
            var itemWidth = NSString(string: text).boundingRect(with: CGSize(width: CGFloat.infinity, height: CGFloat.infinity), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 13)], context: nil).size.width
            itemWidth = CGFloat(ceil(itemWidth))

            let model = EasySegmentedTextModel(text: text, normalColor: .black, selectColor: .red, normalFont: UIFont.systemFont(ofSize: 13), selectFont: UIFont.boldSystemFont(ofSize: 16))
            model.contentWidth = itemWidth
            model.dynamicWidth = itemWidth*16/13
            return model
        }
    }()
    
    fileprivate lazy var containerView: EasyPagingContainerView = {
        let view = EasyPagingContainerView(frame: .zero)
        view.containerDelegate = self
        view.containerDataSource = self
        view.maxExistCount = 5
        view.removeStrategy = .farthest
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "EasySegmentedView"
        view.backgroundColor = .white
        
        segmentedView.defaultSelectedIndex = 8
        containerView.defaultSelectedIndex = 8
        setSubviews()
    }
    
    fileprivate func setSubviews() {
        view.addSubview(segmentedView)
        segmentedView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(0)
            maker.top.equalTo(UIScreen.navigationBarHeight)
            maker.height.equalTo(60)
        }
        
        view.addSubview(containerView)
        containerView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(0)
            maker.top.equalTo(self.segmentedView.snp.bottom)
        }        
    }
}

extension EasySegmentedViewVC: EasySegmentedViewDelegate {
    func segmentedView(_ segmentedView: EasySegmentedView, didSelectedAtIndex index: Int, isSame: Bool) {
        if isSame == false {
            containerView.scroll(toIndex: index, animated: false)
        }
    }
}

extension EasySegmentedViewVC: EasySegmentedViewDataSource {
    func registerCellClass(in segmentedView: EasySegmentedView) {
        segmentedView.register(cellWithClass: EasySegmentedTextCell.self)
    }

    func segmentedItemModels(for segmentedView: EasySegmentedView) -> [EasySegmentBaseItemModel] {
        return listModel
    }
    
    func segmentedView(_ segmentedView: EasySegmentedView, itemViewAtIndex index: Int) -> EasySegmentedBaseCell {
        let cell = segmentedView.dequeueReusableCell(withClass: EasySegmentedTextCell.self, at: index)
        return cell
    }
}


extension EasySegmentedViewVC: EasyPagingContainerViewDelegate {
    func containerViewDidScroll(containerView: EasyPagingContainerView) {
        self.segmentedView.scroll(by: containerView)
    }
    
    func containerView(_ containerView: EasyPagingContainerView, item: EasyPagingContainerItem, addAt index: Int) {
        print("添加: \(index)")
    }
    
    func containerView(_ containerView: EasyPagingContainerView, item: EasyPagingContainerItem, removedAt index: Int) {
        print("删除：\(index)")
    }
}

extension EasySegmentedViewVC: EasyPagingContainerViewDataSource {
    func containerView(_ containerView: EasyPagingContainerView, itemAt index: Int) -> EasyPagingContainerItem? {
        let view = ItemView()
        view.backgroundColor = UIColor.random
        return view
    }
    
    func numberOfItems(in containerView: EasyPagingContainerView) -> Int {
        return list.count
    }
    
    func containerView(_ containerView: EasyPagingContainerView, from fromIndex: Int, to toIndex: Int, percent: CGFloat) {
        if abs(percent) > 0.1 {
            containerView.addSubView(at: toIndex)
        }
    }
    
    func itemWillRemove(of containerView: EasyPagingContainerView, at index: Int) -> Bool {
        index != 0
    }
}


class ItemView: UIView, EasyPagingContainerItem {}
