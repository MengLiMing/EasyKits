//
//  ViewController.swift
//  EasyKits
//
//  Created by MengLiMing on 02/05/2021.
//  Copyright (c) 2021 MengLiMing. All rights reserved.
//

import UIKit
import EasyKits
import SnapKit

class ViewController: UIViewController {
    enum Demo: CaseIterable {
        /// 弹窗
        case popup
        /// 事件
        case responder
        /// scroll嵌套滚动
        case syncScroll
        /// 列表
        case listView
        /// 轮播
        case carouseView
        /// segmentView
        case segmentedView
        /// 嵌套使用
        case nest1
        case nest2
        /// IGListKit
        case iglist

        var data: (title: String, vcType: UIViewController.Type?) {
            switch self {
            case .popup:
                return ("EasyPopup - 一行代码实现弹窗", EasyPopupVC.self)
            case .responder:
                return ("EasyResponder - 事件传递", EasyResponder.self)
            case .syncScroll:
                return ("EasySyncScroll - UIScrollView嵌套", EasySyncScrollVC.self)
            case .listView:
                return ("EasyListView - 数据驱动UITableView", EasyListViewVC.self)
            case .carouseView:
                return ("EasyCarouseView - 自定义轮播", EasyCarouseViewVC.self)
            case .segmentedView:
                return ("EasySegmentedView - 易扩展、易自定义的分段选择器", EasySegmentedViewVC.self)
            case .nest1:
                return ("嵌套使用", NestContainerListVC.self)
            case .nest2:
                return ("嵌套使用", NestSyncContainerListVC.self)
            case .iglist:
                return ("EasyIGList", EasyIGListVC.self)
            }
        }
    }
    
    fileprivate lazy var tableView: EasyListView = {
        let view = EasyListView(frame: .zero, style: .plain)
        view.listDataSource = self
        return view
    }()
    
    fileprivate var sectionModels: [EasyListSectionModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "EasyKits"
        
        demoSections()
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (maker) in
            maker.top.equalTo(UIScreen.navigationHeight)
            maker.left.right.bottom.equalTo(0)
        }
    }
    
    fileprivate func demoSections() {
        sectionModels = Demo.allCases.map { item in
            let sectionModel = EasyListSectionModel()
            sectionModel.add(cellType: VCCell.self, data: item) {[weak self] (cellModel) in
                guard let vcType = (cellModel.data as? Demo)?.data.vcType else {
                    return
                }
                self?.navigationController?.pushViewController(vcType.init(), animated: true)
            }
            sectionModel.addSpace(height: 1, color: UIColor.hex("#F6F6F6"))
            return sectionModel
        }
    }
}

extension ViewController: EasyListViewDataSource {
    func listView(_ listView: EasyListView, modelForSection section: Int) -> EasyListSectionModel? {
        return self.sectionModels.element(section)
    }
    
    func numberOfSections(in listView: EasyListView) -> Int {
        return self.sectionModels.count
    }
}
