//
//  ModuleDelegate.swift
//  ModuleB
//
//  Created by Ming on 2022/2/17.
//

import Foundation
import EasyKits
import ModuleBServices

class ModuleDelegate: NSObject, ModuleProtocol {
    override init() {
        super.init()
        Mediator.shared.register(ModuleServices(), protocolType: ModuleBInterface.self)
    }
    
    func destoryModule() {
        ModuleManager.shared.removeModule(moduleID())
        Mediator.shared.remove(protocolType: ModuleBInterface.self)
    }
}
