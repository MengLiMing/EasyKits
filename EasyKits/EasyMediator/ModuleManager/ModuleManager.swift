//
//  ModuleManager.swift
//  EasyKits
//
//  Created by Ming on 2022/2/17.
//

import Foundation

@objc public final class ModuleManager: NSObject {
    @objc public static var shared: ModuleManager {
        struct Singleton {
            static let single = ModuleManager()
        }
        return Singleton.single
    }
    
    public private(set) var modules: [ModuleProtocol] = []
    
    fileprivate override init() {}
    
    // MARK: Public Method
    public func removeModule(_ moduleID: String) {
        if let index = modules.firstIndex(where: { $0.moduleID() == moduleID }) {
            self.modules.remove(at: index)
        }
    }
    
    public func registerAllModules() {
        var allModules: [ModuleProtocol] = []
        let typeCount = Int(objc_getClassList(nil, 0))
        let types = UnsafeMutablePointer<AnyClass>.allocate(capacity: typeCount)
        let autoreleasingTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
        objc_getClassList(autoreleasingTypes, Int32(typeCount))
        for index in 0..<typeCount {
            if let moduleType = types[index] as? ModuleProtocol.Type,
                let objectClass = moduleType as? NSObject.Type {
                let module = objectClass.init()
                allModules.append(module as! ModuleProtocol)
            }
        }
        types.deallocate()
        allModules.sort { (left, right) -> Bool in
            left.moduleLevel() > right.moduleLevel()
        }
        self.modules.removeAll()
        self.modules.append(contentsOf: allModules)
    }
}
