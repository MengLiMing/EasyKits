//
//  ModuleBServices.swift
//  ModuleB
//
//  Created by Ming on 2022/2/17.
//

import Foundation
import ModuleBServices
import EasyKits

struct ModuleServices: ModuleBInterface {
    func pushLogin(_ success: (() -> Void)?) {
        let vc = ModuleBController()
        vc.loginSuccess = {
            success?()
        }
        Navigator.push(vc)
    }
    
    func loginController(_ success: (() -> Void)?) -> UIViewController {
        let vc = ModuleBController()
        vc.loginSuccess = {
            success?()
        }
        return vc
    }
}
