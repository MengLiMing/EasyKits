//
//  ERAView.swift
//  EasyKits_Example
//
//  Created by 孟利明 on 2021/2/5.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import EasyKits

protocol ERAViewTapHandler {
    func aTaped()
}

class ERAView: UIControl {
    private let bV = ERBView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .red
        self.addSubview(bV)
        bV.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
            maker.width.height.equalToSuperview().multipliedBy(0.5)
        }
        self.addTarget(self, action: #selector(tapAction), for: .touchUpInside)
    }
    
    @objc fileprivate func tapAction() {
        self.delegate(ERAViewTapHandler.self)?.aTaped()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
