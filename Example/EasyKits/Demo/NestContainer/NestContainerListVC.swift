//
//  NestContainerListVC.swift
//  EasyKits_Example
//
//  Created by Ming on 2021/4/29.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import EasyKits
import Then

class NestContainerListVC: UIViewController {
    let segmentView = EasySegmentedView(frame: .zero).then {
        $0.indicatorView = EasySegmentedIndicatorLineView(frame: .zero).then {
            $0.backgroundColor = .red
        }
        $0.tapAnimation = .normal(0.2)
    }
    
    fileprivate lazy var listModel: [EasySegmentedTextModel] = {
        return createListModel(list: ["淘宝", "天猫", "京东", "拼多多", "唯品会"])
    }()
    
    let containerView = EasyPagingContainerView(frame: .zero)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
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
            let model = EasySegmentedTextModel(text: text, normalColor: .black, selectColor: .red, font: UIFont.systemFont(ofSize: 13))
            model.contentWidth = UIScreen.screenWidth / CGFloat(list.count)
            model.maxZoomScale = 16/13
            model.maxStrokeWidth = -5
            return model
        }
    }
}

extension NestContainerListVC: EasySegmentedViewDelegate, EasySegmentedViewDataSource {
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


extension NestContainerListVC: EasyPagingContainerViewDelegate, EasyPagingContainerViewDataSource {
    func containerViewDidScroll(containerView: EasyPagingContainerView) {
        segmentView.scroll(by: containerView.scrollView)
    }
    
    func containerView(_ containerView: EasyPagingContainerView, itemAt index: Int) -> EasyPagingContainerItem? {
        NestContainerSubVC().then {
            $0.title = listModel[index].text
        }
    }
    
    func numberOfItems(in containerView: EasyPagingContainerView) -> Int {
        listModel.count
    }
    
    func containerView(_ containerView: EasyPagingContainerView, from fromIndex: Int, to toIndex: Int, percent: CGFloat) {
        containerView.addSubView(at: toIndex)
    }
}
