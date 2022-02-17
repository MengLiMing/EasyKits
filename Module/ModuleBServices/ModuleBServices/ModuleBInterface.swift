//
//  ModuleBInterface.swift
//  ModuleServices
//
//  Created by Ming on 2022/2/17.
//

import Foundation
import EasyKits

public protocol ModuleBInterface {
    func pushLogin(_ success: (() -> Void)?)
    
    func loginController(_ success: (() -> Void)?) -> UIViewController
}
