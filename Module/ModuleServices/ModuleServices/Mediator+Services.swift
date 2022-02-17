//
//  Mediator+Services.swift
//  Pods
//
//  Created by Ming on 2022/2/17.
//

import Foundation
import EasyKits
import ModuleAServices
import ModuleBServices

public extension Mediator {
    static var aModule: ModuleAInterface? {
        Mediator.shared.provider(ModuleAInterface.self)
    }
    
    
    static var bModule: ModuleBInterface? {
        Mediator.shared.provider(ModuleBInterface.self)
    }
}
