//
//  NestListViewController.swift
//  ShiHuiFeiZhu
//
//  Created by Ming on 2021/8/25.
//

import Foundation
import IGListKit
import RxSwift
import RxCocoa
import EasyKits

extension NestListViewController: SyncScrollInnerProvider {
    var syncInner: SyncInnerScroll {
        collectionView
    }
}

class NestListCollectionView: UICollectionView, SyncInnerScroll { }

class NestListViewController: UIViewController, EasyPagingContainerItem {
    public lazy var collectionView = NestListCollectionView(
        frame: .zero,
        collectionViewLayout: ListCollectionViewLayout(stickyHeaders: false, topContentInset: 0, stretchToEdge: true)
    ).then {
        if #available(iOS 10.0, *) {
            $0.isPrefetchingEnabled = false
        }
        $0.keyboardDismissMode = .onDrag
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
    }
    
    public lazy var adapter = ListAdapter(
        updater: ListAdapterUpdater(),
        viewController: self
    ).then {
        $0.collectionView = collectionView
        $0.dataSource = self
    }
    
    lazy var sections: [ListBaseSection] = (0...20).map { _ in
        ListBaseSection().then {
            $0.add(ListEmptyItem(bgColor: .red, itemHeight: 50))
            $0.insets = .init(top: 10, left: 0, bottom: 0, right: 0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView) { maker in
            maker.leading.trailing.bottom.equalTo(0)
            maker.top(equalToController: self)
        }
        
        adapter.performUpdates(animated: false, completion: nil)
    }
    
    deinit {
        print("\(Self.self)")
    }
}

extension NestListViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        sections
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        ListBindingBaseSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        nil
    }
}
