//
//  EasyListViewVC.swift
//  EasyKits_Example
//
//  Created by 孟利明 on 2021/2/24.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import EasyKits

/// 电商Demo
class EasyListViewVC: UIViewController {
    fileprivate lazy var listView: EasyListView = {
        let v = EasyListView(frame: .zero, style: .plain)
        v.listDataSource = self
        return v
    }()
    
    fileprivate lazy var sectionModel: EasyListSectionModel = {
       let s = EasyListSectionModel()
        
        return s
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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



