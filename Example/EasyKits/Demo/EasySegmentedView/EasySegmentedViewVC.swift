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
        v.itemSpacing = 0
        v.defaultSelectedIndex = 8
        return v
    }()
    
    fileprivate let list = ["精选", "日用百货", "百货", "百货", "百货", "百货", "百货", "百货", "百货", "日用百货", "百货", "百货", "百货", "百货", "百货", "百货", "百货"]
    
    fileprivate lazy var listModel: [EasySegmentedTextModel] = {
        return list.map { text in
            let textWidth = NSString(string: text).boundingRect(with: CGSize(width: CGFloat.infinity, height: CGFloat.infinity), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)], context: nil).size.width
            
            let model = EasySegmentedTextModel(text: text, normalColor: .black, selectColor: .red, normalFont: UIFont.systemFont(ofSize: 13), selectFont: UIFont.boldSystemFont(ofSize: 16))
            let itemWidth = CGFloat(ceil(textWidth))
            model.contentWidth = itemWidth
            model.dynamicWidth = itemWidth + 20
            return model
        }
    }()
    
    fileprivate lazy var containerView: EasyPagingContainerView = {
        let view = EasyPagingContainerView(frame: .zero)
        view.containerDelegate = self
        view.containerDataSource = self
        view.defaultSelectedIndex = 8
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "EasySegmentedView"
        view.backgroundColor = .white
        
        setSubviews()
    }
    
    fileprivate func setSubviews() {
        view.addSubview(segmentedView)
        segmentedView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(0)
            maker.top.equalTo(CGFloat.navBarAndStatusBarHeight)
            maker.height.equalTo(60)
        }
        
        view.addSubview(containerView)
        containerView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(0)
            maker.top.equalTo(self.segmentedView.snp.bottom)
        }
        
        containerView.reloadData()
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
}

extension EasySegmentedViewVC: EasyPagingContainerViewDataSource {
    func containerView(_ containerView: EasyPagingContainerView, itemAtIndex index: Int) -> AnyObject? {
        let view = UIView()
        view.backgroundColor = UIColor.random
        return view
    }
    
    func numberOfItems(in containerView: EasyPagingContainerView) -> Int {
        return list.count
    }
}
