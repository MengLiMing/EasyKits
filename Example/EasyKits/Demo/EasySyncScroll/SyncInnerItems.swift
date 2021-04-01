//
//  SyncInnerItems.swift
//  EasyKits_Example
//
//  Created by 孟利明 on 2021/2/22.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import EasyKits
import WebKit
import MJRefresh

class SyncInnerScrollView: UIScrollView, SyncInnerScroll {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .gray
        self.contentSize = CGSize(width: UIScreen.screenWidth, height: 3000)
        
        self.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {[weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self?.mj_header?.endRefreshing()
            }
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SyncInnerWebView: WKWebView, SyncInnerScroll {
    init() {
        super.init(frame: .zero, configuration: WKWebViewConfiguration())
        self.load(URLRequest(url: URL(string: "https://www.baidu.com")!))
        
        self.scrollView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {[weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self?.scrollView.mj_header?.endRefreshing()
            }
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SyncInnerTableView: UITableView,
                          SyncInnerScroll,
                          UITableViewDelegate,
                          UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = "第\(indexPath.row)行"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.delegate = self
        self.dataSource = self
        self.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {[weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self?.mj_header?.endRefreshing()
            }
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
