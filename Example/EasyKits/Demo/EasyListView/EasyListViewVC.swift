//
//  EasyListViewVC.swift
//  EasyKits_Example
//
//  Created by 孟利明 on 2021/2/24.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import EasyKits
import MJRefresh

class EasyListViewVC: UIViewController {
    fileprivate lazy var listView: EasyListView = {
        let v = EasyListView(frame: .zero, style: .plain)
        v.listDataSource = self
        v.backgroundColor = UIColor.hex("#F8F8F8")
        return v
    }()
    
    fileprivate lazy var sectionModel: EasyListSectionModel = {
       let s = EasyListSectionModel()
        
        return s
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "商品详情demo"
        self.view.backgroundColor = .white
        
        setSubviews()
        configSectionModel()
    }
    
    fileprivate func setSubviews() {
        view.addSubview(listView)
        listView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(0)
            maker.top.equalTo(CGFloat.navBarAndStatusBarHeight)
        }
        
        listView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self?.configSectionModel()
                self?.listView.mj_header?.endRefreshing()
            }
        })
    }
    
    fileprivate func configSectionModel() {
        self.sectionModel.removeAll()
        
        /// 商品轮播图
        sectionModel.add(cellType: EasyCarouseCell.self, data: [
            "http://img.alicdn.com/imgextra/i1/2200651898605/O1CN01yW9TI92DR8nmDzDRB_!!0-item_pic.jpg",
            "http://img.alicdn.com/imgextra/i2/2200651898605/O1CN01Vs5Kvv2DR8nd6Aic5_!!2200651898605.jpg",
            "http://img.alicdn.com/imgextra/i1/2200651898605/O1CN01sYPHkO2DR8ngh8VyX_!!2200651898605.jpg"
        ])
        /// 价格
        sectionModel.add(cellType: EasyListPriceCell.self)
        
        (0...20).forEach { _ in
            /// 模拟根据数据 添加部分cell
            if isAdd() {
                self.sectionModel.addSpace(height: 10, color: .clear)
                self.sectionModel.add(cellType: EasyListOtherCell.self, data: EasyListOtherModel(bgColor: UIColor.random, height: CGFloat((arc4random() % 200) + 10)))
            }
        }
        
        self.listView.reloadData()
    }
    
    fileprivate func isAdd() -> Bool {
        return (arc4random() % 2) % 2 == 0
    }
}


extension EasyListViewVC: EasyListViewDataSource {
    /// 如果页面足够复杂 也可以使用数组 [EasyListSectionModel] 管理
    func listView(_ listView: EasyListView, modelForSection section: Int) -> EasyListSectionModel? {
        return sectionModel
    }
    
    func numberOfSections(in listView: EasyListView) -> Int {
        return 1
    }
}



