//
//  ModuleAController.swift
//  EasyKits
//
//  Created by Ming on 2022/2/17.
//

import Foundation

class ModuleAController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let label = UILabel()
        label.center = view.center
        label.text = "A模块 - A页面"
        label.sizeToFit()
        view.addSubview(label)
    }
    
    
    deinit {
        print("\(Self.self)")
    }
}
