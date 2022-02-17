//
//  ModuleServices.swift
//  ModuleA
//
//  Created by Ming on 2022/2/17.
//

import Foundation
import ModuleAServices

struct ModuleServices: ModuleAInterface {
    func aViewController() -> UIViewController {
        ModuleAController()
    }
}


