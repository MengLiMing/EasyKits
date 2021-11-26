//
//  SnapKit+Ex.swift
//  EasyKits_Example
//
//  Created by Ming on 2021/11/26.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import SnapKit

public extension ConstraintMaker {
    @discardableResult
    func top(equalToController viewController: UIViewController) -> SnapKit.ConstraintMakerEditable {
        if #available(iOS 11.0, *) {
            return top.equalTo(viewController.view.safeAreaLayoutGuide.snp.top)
        } else {
            return top.equalTo(viewController.topLayoutGuide.snp.bottom)
        }
    }
    
    @discardableResult
    func bottom(equalToController viewController: UIViewController) -> SnapKit.ConstraintMakerEditable {
        if #available(iOS 11.0, *) {
            return bottom.equalTo(viewController.view.safeAreaLayoutGuide.snp.bottom)
        } else {
            return bottom.equalTo(viewController.bottomLayoutGuide.snp.top)
        }
    }
}
