//
//  ModuleBController.swift
//  EasyKits
//
//  Created by Ming on 2022/2/17.
//

import Foundation

class ModuleBController: UIViewController {
    var loginSuccess: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let label = UILabel()
        label.center = view.center
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "B模块 - B页面 \n 点击页面登录"
        label.sizeToFit()
        view.addSubview(label)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.navigationController?.popViewController(animated: true)
        loginSuccess?()
    }
    
    deinit {
        print("\(Self.self)")
    }
}
