//
//  Bundle+Ex.swift
//  EasyKits
//
//  Created by Ming on 2021/11/26.
//

import Foundation

public extension Bundle {
    static func frameworkBundle(for frameworkClass: AnyClass?) -> Bundle {
        guard let frameworkClass = frameworkClass else {
            return Bundle.main
        }
        return Bundle(for: frameworkClass)
    }
    
    
    func bundle(for bundleName: String) -> Bundle? {
        guard let url = self.url(forResource: bundleName, withExtension: "bundle") else {
            return nil
        }
        
        return Bundle(url: url)
    }
}
