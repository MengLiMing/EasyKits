//
//  EasyResponder.swift
//  EasyKits_Example
//
//  Created by 孟利明 on 2021/2/5.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit

class EasyResponder: UIViewController {
    let ac = ERAView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(ac)
        ac.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
            maker.width.height.equalTo(CGFloat.screenWidth - 40)
        }
    }
}

/// view层级太多 如果使用block嵌套 或者delegate设置等 代码会变得比较难看
extension EasyResponder: ERAViewTapHandler,
                         ERBViewTapHandler,
                         ERCViewTapHandler {
    func aTaped() {
        print("点击了A")
    }
    
    func bTaped(_ view: ERBView) {
        print("点击了B")
    }
    
    func cTaped() {
        print("点击了C")
    }
}
