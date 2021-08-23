//
//  EasyPopupVC.swift
//  EasyKits_Example
//
//  Created by 孟利明 on 2021/2/5.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import EasyKits

class EasyPopupVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    let alertV = DemoAlertView()
     
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        alertV.show()
    }
}

extension DemoAlertView: ViewTransferAnimatorProvider { }
class DemoAlertView: UIView {
    func transferAnimator() -> ViewAnimationProdiver {
        return CustomViewAnimation(animation: .normal,
                                   startPosition: .outer(.bottom),
                                   endPosition: .inner(.center),
                                   transfers: [])
    }
    
    fileprivate lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
            maker.width.equalTo(UIScreen.screenWidth - 40)
            maker.height.equalTo(200)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
