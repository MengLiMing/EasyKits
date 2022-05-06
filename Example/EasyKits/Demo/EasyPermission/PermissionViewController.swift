//
//  PermissionViewController.swift
//  EasyKits_Example
//
//  Created by Ming on 2022/5/5.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Then
import EasyKits
import RxSwift

class PermissionViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    private lazy var cameraButton = UIButton().then {
        $0.backgroundColor = .blue
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("相机权限", for: .normal)
    }
    
    private var authStatus: PermissionStatus? {
        didSet {
            if let authStatus = authStatus {
                self.statusChanged(status: authStatus)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(cameraButton) { maker in
            maker.center.equalToSuperview()
            maker.width.equalTo(200)
            maker.height.equalTo(50)
        }
        
        Permission.camera.status { status in
            self.authStatus = status
        }
        
        cameraButton.rx.tap
            .flatMapLatest {
                Permission.camera.access
            }
            .subscribe(onNext: {[weak self] status in
                self?.authStatus = status
            })
            .disposed(by: disposeBag)
    }
    
    func statusChanged(status: PermissionStatus) {
        if status.isAuthorized {
           cameraButton.setTitle("已获取相机权限", for: .normal)
        } else if status.isNotDetermined {
            cameraButton.setTitle("未申请相机权限", for: .normal)
        } else if status.isDenied {
            cameraButton.setTitle("已拒绝相机权限", for: .normal)
        }
    }
}
