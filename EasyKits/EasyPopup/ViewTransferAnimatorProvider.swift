//
//  EasySegmentedBaseCell.swift
//  EasyKits
//
//  Created by 孟利明 on 2021/2/25.
//

import Foundation

/// UIView 遵循此协议即可实现show和dismiss 注意：UIView的大小由内部元素填充撑开
public protocol ViewTransferAnimatorProvider {
    func transferAnimator() -> ViewAnimationProdiver
}

public extension ViewTransferAnimatorProvider {
    func transferAnimator() -> ViewAnimationProdiver {
        return CustomViewAnimation(animation: .normal,
                                   startPosition: .outer(.bottom),
                                   endPosition: .inner(.bottom),
                                   transfers: [])
    }
}

private var view_transfer_animator_dimmingConfig: UInt8 = 0

public extension ViewTransferAnimatorProvider where Self: UIView {
    fileprivate var dimmingConfig: DimmingViewConfig {
        set {
            objc_setAssociatedObject(self, &view_transfer_animator_dimmingConfig, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            if let config = objc_getAssociatedObject(self, &view_transfer_animator_dimmingConfig) as? DimmingViewConfig {
                return config
            }
            let config = DimmingViewConfig()
            /// 默认点击隐藏
            config.dimmingTapped = { [weak self] in
                self?.dismiss()
            }
            objc_setAssociatedObject(self, &view_transfer_animator_dimmingConfig, config, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return config
        }
    }
    
    /// 背景点击
    var dimmingTapped: (() -> Void)? {
        set {
            dimmingConfig.dimmingTapped = newValue
        }
        
        get {
            dimmingConfig.dimmingTapped
        }
    }
    
    /// 背景层透明度
    var dimmingAlpha: CGFloat {
        set {
            dimmingConfig.dimmingAlpha = newValue
        }
        
        get {
            dimmingConfig.dimmingAlpha
        }
    }
    
    /// 背景层颜色
    var dimmingColor: UIColor {
        set {
            dimmingConfig.dimmingColor = newValue
        }
        
        get {
            dimmingConfig.dimmingColor
        }
    }
    
    fileprivate var dimmingView: DimmingView {
        dimmingConfig.dimmingView
    }
}

public extension ViewTransferAnimatorProvider where Self: UIView {
    /// transferAnimator() 执行动画
    func show(showInView: UIView? = UIApplication.shared.keyWindow,
              completion: ((Bool) -> Void)? = nil) {
        let animator = transferAnimator()
        dimmingView.dimmingShow(
            showInView: showInView,
            animation: animator.animation,
            targetAlpha: dimmingAlpha)
        
        showInView?.addSubview(self)
        animator.startAnimation(self, completion: completion)
    }
    
    /// transferAnimator() 执行动画
    func dismiss(completion: ((Bool) -> Void)? = nil) {
        let animator = transferAnimator()
        dimmingView.dimmingDismiss(animation: animator.animation)
        animator.endAnimation(self) { [weak self] in
            completion?($0)
            self?.dimmingView.removeFromSuperview()
            self?.removeFromSuperview()
        }
    }
    
    /// 自定义动画 - 单独执行此动画之后 默认的dismiss动画依然是以 transferAnimator() 中设置的为准 可以在dimmingTapped 中调用dismiss方法
    func show(showInView: UIView? = UIApplication.shared.keyWindow,
              animation: ViewAnimation,
              startPosition: ViewPosition,
              endPosition: ViewPosition,
              transfers: [ViewTransfer] = [],
              completion: ((Bool) -> Void)? = nil) {
        guard let showInView = showInView else {
            return
        }
        dimmingView.dimmingShow(
            showInView: showInView,
            animation: animation,
            targetAlpha: dimmingAlpha)
        
        showInView.addSubview(self)
        self.layout(from: startPosition, to: endPosition)
            .layoutAnimation(
                by: animation,
                transfers: transfers,
                completion: completion)
    }
    
    /// 自定义动画
    func dismiss(animation: ViewAnimation,
                 position: ViewPosition,
                 transfers: [ViewTransfer] = [],
                 completion: ((Bool) -> Void)? = nil) {
        guard self.superview != nil else {
            return
        }
        dimmingView.dimmingDismiss(animation: animation)
        self.layout(by: position)
            .layoutAnimation(
                by: animation,
                transfers: transfers,
                isStart: false) { [weak self] in
                completion?($0)
                self?.dimmingView.removeFromSuperview()
                self?.removeFromSuperview()
            }
    }
}


fileprivate class DimmingViewConfig {
    /// 点击背景回调
    var dimmingTapped: (() -> Void)?
    
    /// 透明层
    lazy var dimmingView: DimmingView = {
        let view = DimmingView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapped(_:))))
        view.isUserInteractionEnabled = true
        view.alpha = dimmingAlpha
        view.backgroundColor = dimmingColor
        return view
    }()
    
    /// 背景层透明度
    var dimmingAlpha: CGFloat = 0.8 {
        didSet {
            dimmingView.alpha = dimmingAlpha
        }
    }
    /// 背景层颜色
    var dimmingColor: UIColor = UIColor.black {
        didSet {
            dimmingView.backgroundColor = dimmingColor
        }
    }
    
    @objc private func dimmingViewTapped(_ sender: UITapGestureRecognizer) {
        dimmingTapped?()
    }
}

fileprivate class DimmingView: UIView, ViewTransferAnimatorProvider {
    func dimmingShow(showInView: UIView?, animation: ViewAnimation, targetAlpha: CGFloat) {
        guard let showInView = showInView else {
            return
        }
        showInView.addSubview(self)
        self.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        self.alpha = 0
        animation.animation {
            self.alpha = targetAlpha
        } completion: { _ in
            self.alpha = targetAlpha
        }
    }
    
    func dimmingDismiss(animation: ViewAnimation) {
        guard self.superview != nil else {
            return
        }
        animation.animation {
            self.alpha = 0
        } completion: { _ in
            self.alpha = 0
        }

    }
}


// MARK: Demo
//class PopView: UIView, ViewTransferAnimatorProvider {
//    let contentView = UIView().then {
//        $0.backgroundColor = .red
//    }
//
//    override func setupUI() {
//        addSubview(contentView)
//        contentView.snp.makeConstraints { maker in
//            maker.edges.equalToSuperview()
//            maker.width.equalTo(UIScreen.screenWidth)
//            maker.height.equalTo(UIScreen.screenHeight/2)
//        }
//    }
//}
// 使用： PopView().show()
//let vvv = PopView()
//vvv.dimmingTapped = {[weak vvv] in
//    vvv?.dismiss(animation: .normal, position: .outer(.bottom))
//}
//vvv.show(showInView: self.view, animation: .normal, startPosition: .outer(.bottom), endPosition: .inner(.bottom), transfers: [.alpha(from: 0, to: 1)], completion: nil)
