//
//  EasyIGListVC.swift
//  EasyKits_Example
//
//  Created by Ming on 2021/11/4.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import IGListKit
import IGListDiffKit
import Then
import EasyKits
import SnapKit
import RxSwift

class EasyIGListVC: UIViewController {
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: ListCollectionViewLayout(stickyHeaders: false, topContentInset: 0, stretchToEdge: true))
        .then {
            $0.backgroundColor = .white
            if #available(iOS 10.0, *) {
                $0.isPrefetchingEnabled = false
            }
            $0.keyboardDismissMode = .onDrag
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
        }
    
    lazy var adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0).then {
        $0.collectionView = collectionView
        $0.dataSource = self
    }
    
    lazy var dataSource: [ListDiffable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalTo(0)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                make.top.equalTo(self.topLayoutGuide.snp.bottom)
            }
        }
        
        Observable.just(1).delay(.seconds(2), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    let disposeBag = DisposeBag()
    
    func reloadData() {
        let section = ListBaseSection()
        for i in 0..<10 {
            section.add(Item1("测试\(i)").then {
                $0.selectedEvent.subscribe(onNext: { value in
                    print(value.index)
                    if let data = value.data as? Item1 {
                        print(data.content)
                    }
                })
                    .disposed(by: disposeBag)
            })
        }
        dataSource = [section]
        adapter.performUpdates(animated: true, completion: nil)
    }
}

extension EasyIGListVC: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        dataSource
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        (object as? ListSectionControllerProvider)?.sectionController() ?? ListBindingBaseSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        nil
    }
}


class Item1: ListBaseItemDataType,
             ListBaseItemSeparatorStyleProvider,
             ListBaseItemSelectionHandlerProvider {
    let content: String
    
    init(_ content: String) {
        self.content = content
    }
    
    func itemSize(_ sectionController: ListSectionController) -> CGSize {
        return .init(width: sectionController.contentWidth, height: 60)
    }
    
    var itemType: ListBindableCell.Type = Item1Cell.self
    
    var separatorStyle: ListItemSeparatorStyle = .bottom()
}

class Item1Cell: ListSeparatorBindableDataCell<Item1> {
    let label = UILabel().then {
        $0.textColor = .black
        $0.textAlignment = .center
    }
    
    override func setupUI() {
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func bindData(_ data: Item1) {
        label.text = data.content
    }
}
