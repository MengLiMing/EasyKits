//
//  RouterTarget+ModuleB.swift
//  ModuleServices
//
//  Created by Ming on 2022/2/17.
//

import Foundation
import EasyKits

extension RouterTarget {
    private var bModule: ModuleBInterface? {
        Mediator.shared.provider(ModuleBInterface.self)
    }
    
    @objc func pushLogin(_ params: [String: Any]?) {
        guard let callBack = params?.routerCallBack else {
            return
        }
        guard let bModule = bModule else {
            callBack(RouterError.noAction, "", nil)
            return
        }
        let vc = bModule.loginController {
            callBack(nil, nil, nil)
        }
        Navigator.push(vc)
    }
}
