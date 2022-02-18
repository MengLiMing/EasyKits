//
//  ModuleDelegate.swift
//  ModuleB
//
//  Created by Ming on 2022/2/17.
//

import Foundation
import EasyKits
import ModuleAServices

class ModuleDelegate: NSObject, ModuleProtocol {
    override init() {
        super.init()
        Mediator.shared.register(ModuleServices(), protocolType: ModuleAInterface.self)
    }
    
    func destoryModule() {
        ModuleManager.shared.removeModule(moduleID())
        Mediator.shared.remove(protocolType: ModuleAInterface.self)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        print("AModule didFinishLaunching")
        return true
    }
}
