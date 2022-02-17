//
//  RouterTarget+ModuleA.swift
//  EasyKits
//
//  Created by Ming on 2022/2/17.
//

import Foundation
import EasyKits

extension RouterTarget {
    private var aModule: ModuleAInterface? {
        Mediator.shared.provider(ModuleAInterface.self)
    }
    
    @objc func aController(_ params: [String: Any]?) {
        guard let callBack = params?.routerCallBack else {
            return
        }
        guard let aModule = aModule else {
            callBack(RouterError.noAction, "", nil)
            return
        }
        callBack(nil, nil, aModule.aViewController())
    }
}
