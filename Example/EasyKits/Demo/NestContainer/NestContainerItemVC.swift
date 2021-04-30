//
//  NestContainerItemVC.swift
//  EasyKits_Example
//
//  Created by Ming on 2021/4/29.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import EasyKits

extension NestContainerItemVC: EasyPagingContainerItem { }
extension NestContainerItemVC: SyncScrollInnerProvider {
    var syncInner: SyncInnerScroll {
        return scrollView
    }
}
class InnerScroll: UIScrollView, SyncInnerScroll { }
class NestContainerItemVC: UIViewController {
    override var title: String? {
        didSet {
            label.text = title
        }
    }
    
    let label = UILabel().then {
        $0.textColor = .white
        $0.font = .boldSystemFont(ofSize: 40)
        $0.textAlignment = .center
    }

    let scrollView = InnerScroll()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.backgroundColor = UIColor.random
        view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: UIScreen.screenWidth, height: 1500)
        scrollView.addSubview(label)
        scrollView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        label.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(100)
        }
    }
}


extension NestContainerItemVC {
    func scrollToTop() {
        self.scrollView.contentOffset = .zero
    }
}
