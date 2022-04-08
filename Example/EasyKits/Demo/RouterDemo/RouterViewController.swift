//
//  RouterViewController.swift
//  EasyKits_Example
//
//  Created by Ming on 2022/2/17.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import EasyKits
import ModuleServices

class RouterViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    let aB = UIButton().then {
        $0.setTitle("A模块 - 需要登录", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }
    
    let aB1 = UIButton().then {
        $0.setTitle("A模块 - 不需要登录", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }
    
    let bB = UIButton().then {
        $0.setTitle("B模块 - url", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }
    
    let bB1 = UIButton().then {
        $0.setTitle("B模块 - protocol", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }
    
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(aB) { maker in
            maker.width.equalTo(200)
            maker.height.equalTo(50)
            maker.center.equalToSuperview()
        }
        view.addSubview(aB1) { maker in
            maker.size.equalTo(self.aB)
            maker.centerX.equalTo(self.aB)
            maker.top.equalTo(self.aB.snp.bottom).offset(10)
        }
        
        view.addSubview(bB) { maker in
            maker.size.equalTo(self.aB1)
            maker.centerX.equalTo(self.aB1)
            maker.top.equalTo(self.aB1.snp.bottom).offset(10)
        }
        
        view.addSubview(bB1) { maker in
            maker.size.equalTo(self.bB)
            maker.centerX.equalTo(self.bB)
            maker.top.equalTo(self.bB.snp.bottom).offset(10)
        }
        
        view.addSubview(label) { maker in
            maker.centerX.equalTo(self.bB1)
            maker.top.equalTo(self.bB1.snp.bottom).offset(10)
        }
        
        ///1、easyKits://aController?isNeedLogin=1
        ///2、easyKits://pushLogin
        
        aB.rx.tap
            .subscribe(onNext: { _ in
                Router.shared.router("easyKits://aController?isNeedLogin=1") { error, message, args in
                    /// 此处表现为先登录 登陆成功之后 再跳转
                    guard let vc = args as? UIViewController else {
                        return
                    }
                    Navigator.push(vc)
                }
            })
            .disposed(by: disposeBag)
        
        aB1.rx.tap
            .subscribe(onNext: { _ in
                Router.shared.router("easyKits://aController") { error, message, args in
                    guard let vc = args as? UIViewController else {
                        return
                    }
                    Navigator.push(vc)
                }
            })
            .disposed(by: disposeBag)
        
        bB.rx.tap
            .subscribe(onNext: {[weak self] _ in
                Router.shared.router("easyKits://pushLogin") { error, message, args in
                    self?.label.text = "路由登录成功"
                }
            })
            .disposed(by: disposeBag)
        
        bB1.rx.tap
            .subscribe(onNext: {[weak self] _ in
                Mediator.bModule?.pushLogin({
                    self?.label.text = "协议登录成功"
                })
            })
            .disposed(by: disposeBag)
    }
}
