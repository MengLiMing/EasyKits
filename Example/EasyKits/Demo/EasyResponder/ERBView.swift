//
//  ERBView.swift
//  EasyKits_Example
//
//  Created by 孟利明 on 2021/2/5.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import EasyKits

protocol ERBViewTapHandler {
    func bTaped(_ view: ERBView)
}

class ERBView: UIControl {
    private let bV = ERCView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .green
        self.addSubview(bV)
        bV.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
            maker.width.height.equalToSuperview().multipliedBy(0.5)
        }
        self.addTarget(self, action: #selector(tapAction), for: .touchUpInside)
    }
    
    @objc fileprivate func tapAction() {
        self.delegate(ERBViewTapHandler.self)?.bTaped(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
