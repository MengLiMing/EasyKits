//
//  NestCategoryViewController.swift
//  ShiHuiFeiZhu
//
//  Created by Ming on 2021/8/25.
//

import Foundation
import IGListKit
import EasyKits

class NestContainerView: EasyPagingContainerView, SyncScrollContainer {
    func resetContainerItems(_ resetItem: (SyncInnerScroll) -> ()) {
        self.items.values.forEach {
            if let item = $0 as? SyncScrollInnerProvider {
                resetItem(item.syncInner)
            }
        }
    }
}

class NestCategoryViewController: UIViewController, EasyNestListPagingContainer {
    var horizontalScrollView: SyncScrollContainer {
        return containerView
    }
    
    var innerScrollChangeHandler: ((SyncInnerScroll) -> Void)?
    
    fileprivate lazy var listModel: [EasySegmentedTextModel] = {
        return createListModel(list: ["推荐", "风景", "自我游", "其他"])
    }()
    
    private lazy var segmentView: EasySegmentedView = {
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
    
    
    private lazy var containerView = NestContainerView(frame: .zero).then {
        $0.delegate = self
        $0.dataSource = self
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(segmentView) { maker in
            maker.leading.trailing.equalTo(0)
            maker.height.equalTo(44).priority(.high)
            maker.top(equalToController: self)
        }
        
        view.addSubview(containerView) { maker in
            maker.leading.trailing.bottom.equalTo(0)
            maker.top.equalTo(self.segmentView.snp.bottom)
        }
        
        segmentView.reloadData()
        containerView.reloadData()
    }
    
    func createListModel(list: [String]) -> [EasySegmentedTextModel] {
        list.map { text in
            var itemWidth = NSString(string: text).boundingRect(with: CGSize(width: CGFloat.infinity, height: CGFloat.infinity), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)], context: nil).size.width
            itemWidth = CGFloat(ceil(itemWidth))

            let model = EasySegmentedTextModel(text: text, normalColor: .black, selectColor: .red, font: UIFont.systemFont(ofSize: 16))
            model.contentWidth = self.view.frame.size.width/4
            model.maxStrokeWidth = -2
            return model
        }
    }
    
    deinit {
        print("\(Self.self)")
    }
}

extension NestCategoryViewController: EasyPagingContainerViewDelegate, EasyPagingContainerViewDataSource {
    func containerView(_ containerView: EasyPagingContainerView, itemAt index: Int) -> EasyPagingContainerItem? {
        NestListViewController()
    }
    
    func numberOfItems(in containerView: EasyPagingContainerView) -> Int {
        listModel.count
    }
    
    func containerViewDidScroll(containerView: EasyPagingContainerView) {
        self.segmentView.scroll(by: containerView.scrollView)
    }
    
    func containerView(_ containerView: EasyPagingContainerView, item: EasyPagingContainerItem, stopAt index: Int) {
        if let item = item as? SyncScrollInnerProvider {
            innerScrollChangeHandler?(item.syncInner)
        }
    }
}

extension NestCategoryViewController: EasySegmentedViewDelegate {
    func segmentedView(_ segmentedView: EasySegmentedView, didSelectedAtIndex index: Int, isSame: Bool) {
        if isSame == false {
            containerView.scroll(toIndex: index, animated: true)
        }
    }
}

extension NestCategoryViewController: EasySegmentedViewDataSource {
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
