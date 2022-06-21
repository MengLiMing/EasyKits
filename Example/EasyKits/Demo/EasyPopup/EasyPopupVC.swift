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
    fileprivate let tests = PopupEndPosition.allCases
    
    fileprivate var index = 0
    
    fileprivate var currentPosition: PopupEndPosition {
        get {
            tests[index]
        }
    }
    
    fileprivate lazy var button = UIButton(type: .custom).then {
        $0.setTitle("切换弹出类型", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .blue
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        $0.addTarget(self, action: #selector(changePositionStyle), for: .touchUpInside)
    }
    
    fileprivate lazy var button1 = UIButton(type: .custom).then {
        $0.setTitle("弹出", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .blue
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        $0.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
    }
    
    fileprivate lazy var label = UILabel().then {
        $0.text = currentPosition.description
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(button) { maker in
            maker.centerX.equalToSuperview()
            maker.bottom.equalTo(view.snp.centerY).offset(-10)
            maker.width.equalTo(100)
            maker.height.equalTo(60)
        }
        
        view.addSubview(button1) { maker in
            maker.top.equalTo(view.snp.centerY).offset(10)
            maker.centerX.equalToSuperview()
            maker.width.equalTo(100)
            maker.height.equalTo(60)
        }
        
        view.addSubview(label) { maker in
            maker.bottom.equalTo(self.button.snp.top).offset(-10)
            maker.centerX.equalTo(self.button.snp.centerX)
        }
    }
    
    
    
    lazy var alertV = DemoAlertView()
     
    @objc fileprivate func changePositionStyle() {
        index += 1
        index %= tests.count
        alertV.position = currentPosition
        label.text = currentPosition.description
    }
    
    @objc fileprivate func showAlert() {
        alertV.show()
    }
}

enum PopupEndPosition: CaseIterable, CustomStringConvertible {
    case bottomToTop
    case bottomToCenter
    case leftToLeft
    case leftToRight
    case rightToLeft
    
    var description: String {
        switch self {
        case .bottomToTop:
            return "底 -> 上"
        case .bottomToCenter:
        return "底 -> 中心"
        case .leftToLeft:
            return "左 -> 左"
        case .leftToRight:
            return "左 -> 右"
        case .rightToLeft:
            return "右 -> 左"
        }
    }
}

extension DemoAlertView: ViewTransferAnimatorProvider { }
class DemoAlertView: UIView {
    func transferAnimator() -> ViewAnimationProdiver {
        switch position {
        case .bottomToTop:
            return CustomViewAnimation(animation: .normal,
                                       startPosition: .outer(.bottom),
                                       endPosition: .inner(.top(UIScreen.statusBarHeight)),
                                       transfers: [])
        case .bottomToCenter:
            return CustomViewAnimation(animation: .normal,
                                       startPosition: .outer(.bottom),
                                       endPosition: .inner(.center(20, -(UIScreen.screenHeight - 200)/2)),
                                       transfers: [])
        case .leftToLeft:
            return CustomViewAnimation(animation: .normal,
                                       startPosition: .outer(.left),
                                       endPosition: .inner(.left(20)),
                                       transfers: [])
        case .leftToRight:
            return CustomViewAnimation(animation: .normal,
                                       startPosition: .outer(.left),
                                       endPosition: .inner(.right(20)),
                                       transfers: [])
        case .rightToLeft:
            return CustomViewAnimation(animation: .normal,
                                       startPosition: .outer(.right),
                                       endPosition: .inner(.left),
                                       transfers: [])
        
        }
        
    }
    
    fileprivate var position: PopupEndPosition
    
    fileprivate lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .white
        return label
    }()
    
    init(position: PopupEndPosition = .bottomToTop) {
        self.position = position;
        super.init(frame: .zero)
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
