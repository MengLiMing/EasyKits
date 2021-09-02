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
        let indicatorView = EasySegmentedIndicatorLineView(frame: .zero)
        indicatorView.backgroundColor = .red
        indicatorView.lineWidth = .fixed(20)
        v.indicatorView = indicatorView
        v.tapAnimation = .byScroll
        return v
    }()
        
    fileprivate lazy var listModel: [EasySegmentedTextModel] = {
        return createListModel(list: ["精选", "百货"])
    }()
    
    fileprivate lazy var containerView: EasyPagingContainerView = {
        let view = EasyPagingContainerView(frame: .zero)
        view.delegate = self
        view.dataSource = self
//        view.maxExistCount = 5
//        view.removeStrategy = .farthest
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "EasySegmentedView"
        view.backgroundColor = .white

        setSubviews()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "刷新", style: .plain, target: self, action: #selector(reloadData))
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
    
    @objc fileprivate func reloadData() {
        listModel = createListModel(list: ["精选精选精选精选精选精选精选", "百货百货百货", "百货百货百货百货", "百货百货百货百货百货百货"])
        let selectedIndex = Int.random(in: 0..<listModel.count)
        segmentedView.reloadData(selectedAt: selectedIndex)
        containerView.reloadData(selectedAt: selectedIndex)
    }
    
    func createListModel(list: [String]) -> [EasySegmentedTextModel] {
        list.map { text in
            var itemWidth = NSString(string: text).boundingRect(with: CGSize(width: CGFloat.infinity, height: CGFloat.infinity), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)], context: nil).size.width
            itemWidth = CGFloat(ceil(itemWidth))

            let model = EasySegmentedTextModel(text: text, normalColor: .black, selectColor: .red, font: UIFont.systemFont(ofSize: 16))
            model.contentWidth = self.view.frame.size.width/2
            model.maxStrokeWidth = -2
            return model
        }
    }
}

extension EasySegmentedViewVC: EasySegmentedViewDelegate {
    func segmentedView(_ segmentedView: EasySegmentedView, didSelectedAtIndex index: Int, isSame: Bool) {
        if isSame == false {
            containerView.scroll(toIndex: index, animated: true)
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
        self.segmentedView.scroll(by: containerView.scrollView)
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
        let model = listModel[index]
        view.label.text = model.text
        view.backgroundColor = UIColor.random
        return view
    }
    
    func numberOfItems(in containerView: EasyPagingContainerView) -> Int {
        return listModel.count
    }
    
    func containerView(_ containerView: EasyPagingContainerView, from fromIndex: Int, to toIndex: Int, percent: CGFloat) {
//        if abs(percent) > 0.1 {
//            containerView.addSubView(at: toIndex)
//        }
        containerView.addSubView(at: toIndex)
    }
    
    func itemWillRemove(of containerView: EasyPagingContainerView, at index: Int) -> Bool {
        index != 0
    }
}


class ItemView: UIView, EasyPagingContainerItem {
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 40)
        label.textAlignment = .center
        self.addSubview(label)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.sizeToFit()
        label.center = .init(x: bounds.width/2, y: bounds.height/2)
    }
}
