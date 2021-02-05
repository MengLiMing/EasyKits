//
//  ERCView.swift
//  EasyKits_Example
//
//  Created by 孟利明 on 2021/2/5.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import EasyKits

protocol ERCViewTapHandler {
    func cTaped()
}
class ERCView: UIControl {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .blue

        self.addTarget(self, action: #selector(tapAction), for: .touchUpInside)
    }
    
    @objc fileprivate func tapAction() {
        self.delegate(ERCViewTapHandler.self)?.cTaped()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
