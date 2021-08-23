//
//  EasySegmentedBaseCell.swift
//  EasyKits
//
//  Created by 孟利明 on 2021/2/25.
//

import UIKit
import SnapKit

private let dimmingDefaultBgColor: UIColor = UIColor.black
private let dimmingDefaultAlpha: CGFloat = 0.8

///注： 使用时 不要设置view的宽高，大小由内部元素填充撑开
open class PresentationViewController: UIViewController {
    /// 点击背景回调
    public lazy var dimmingTapped: (() -> Void)? = { [weak self] () -> Void in
        self?.dismiss(animated: true, completion: nil)
    }
    
    /// 透明层
    public weak var dimmingView: UIView?
    /// 背景层透明度
    public var dimmingAlpha: CGFloat = dimmingDefaultAlpha
    /// 背景层颜色
    public var dimmingColor: UIColor = dimmingDefaultBgColor
    
    public convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        config()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        config()
    }
    
    private func config() {
        transitioningDelegate = self
        modalPresentationStyle = .custom
        modalPresentationCapturesStatusBarAppearance = true
    }

    /// present/dismiss使用一种动画, 可重写
    /// - Returns: 动画
    open func animator() -> PresentationAnimator {
        PresentationAnimator()
    }
    
    
    /// present动画 默认为 animator()， 可重写
    /// - Returns: 动画
    open func presentAnimator() -> PresentationAnimator {
        animator()
    }
    
    /// dismiss动画 默认为 animator()， 可重写
    /// - Returns: 动画
    open func dismissAnimator() -> PresentationAnimator {
        animator()
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

extension PresentationViewController: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentAnimator()
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        dismissAnimator()
    }
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = PresentationController(presentedViewController: presented, presenting: source)
        presentationController.dimmingTapHandler = {[weak self] in
            self?.dimmingTapped?()
        }
        presentationController.dimmingAlphaConfig = {[weak self] in
            return self?.dimmingAlpha ?? dimmingDefaultAlpha
        }
        presentationController.dimmingColorConfig = {[weak self] in
            return self?.dimmingColor ?? dimmingDefaultBgColor
        }
        presentationController.dimmingViewCallBack = {[weak self] view in
            self?.dimmingView = view
        }
        return presentationController
    }
}

fileprivate class PresentationController: UIPresentationController {
    private(set) var dimmingView: UIView? {
        didSet {
            self.dimmingViewCallBack?(dimmingView)
        }
    }
    
    var dimmingViewCallBack: ((UIView?) -> Void)?

    private(set) var presentationWrappingView: UIView?
    
    var dimmingAlphaConfig: (() -> CGFloat)?
    
    var dimmingColorConfig: (() -> UIColor)?
    
    
    var dimmingTapHandler: (() -> Void)?
    
    private var dimmingAlpha: CGFloat {
        return dimmingAlphaConfig?() ?? dimmingDefaultAlpha
    }
    
    private var dimmingColor: UIColor {
        return dimmingColorConfig?() ?? dimmingDefaultBgColor
    }
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        presentedViewController.modalPresentationStyle = .custom
    }
    
    /// 展现控制器的视图
    override var presentedView: UIView? {
        return presentationWrappingView
    }
    
    override func presentationTransitionWillBegin() {
        guard let presentedViewControllerView = super.presentedView,
              let containerView = self.containerView else {
            return
        }
        
        let presentationWrapperView = UIView(frame: .zero)
        self.presentationWrappingView = presentationWrapperView
        presentationWrapperView.backgroundColor = UIColor.clear
        presentationWrapperView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        presentationWrapperView.addSubview(presentedViewControllerView)
        presentedViewControllerView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        let dimmingView = UIView(frame: containerView.bounds)
        dimmingView.backgroundColor = dimmingColor
        dimmingView.isOpaque = false
        dimmingView.autoresizingMask = .flexibleWidth.union(.flexibleHeight)
        dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapped(_:))))
        self.dimmingView = dimmingView
        containerView.addSubview(dimmingView)

        self.dimmingView?.alpha = 0
        presentingViewController
            .transitionCoordinator?
            .animate(
                alongsideTransition: { [weak self] _ in
                    self?.dimmingView?.alpha = self?.dimmingAlpha ?? dimmingDefaultAlpha
                },
                completion: nil
            )
    }
    
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if completed == false {
            presentationWrappingView = nil
            dimmingView = nil
        }
    }
    
    override func dismissalTransitionWillBegin() {
        presentingViewController
            .transitionCoordinator?
            .animate(
                alongsideTransition: { [weak self] _ in
                    self?.dimmingView?.alpha = 0
                },
                completion: nil
            )
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            self.presentationWrappingView = nil
            self.dimmingView = nil
        }
    }
    
    @objc private func dimmingViewTapped(_ sender: UITapGestureRecognizer) {
        dimmingTapHandler?()
    }
}

public class PresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning, ViewAnimationProdiver {
    
    public var animation: ViewAnimation = ViewAnimation.normal
    public var startPosition: ViewPosition = .outer(.bottom)
    public var endPosition: ViewPosition = .inner(.bottom)
    public var transfers: [ViewTransfer] = [.none]
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return (transitionContext?.isAnimated ?? false) ? animation.duration : 0
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to) else {
            return
        }
        let containerView = transitionContext.containerView
        
        let fromView = transitionContext.view(forKey: .from) ?? fromVC.view!
        let toView = transitionContext.view(forKey: .to) ?? toVC.view!
        
        let isPresenting = toVC.presentingViewController == fromVC

        let completion: (Bool) -> Void = { _ in
            let wasCancelled = transitionContext.transitionWasCancelled
            if isPresenting {
                if wasCancelled {
                    toView.removeFromSuperview()
                }
            } else {
                fromView.removeFromSuperview()
            }
            transitionContext.completeTransition(!wasCancelled)
        }
        if isPresenting {
            containerView.addSubview(toView)
            startAnimation(toView, completion: completion)
        } else {
            endAnimation(fromView, completion: completion)
        }
    }
}


// MARK: Demo
//class PopViewController: PresentationViewController {
//
//    let btn: UIButton = {
//       let btn = UIButton()
//        btn.backgroundColor = .black
//        btn.setTitle("Dismiss", for: .normal)
//        return btn
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .green
//        btn.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
//        view.addSubview(btn)
//        btn.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//            make.width.equalTo(100)
//            make.height.equalTo(50)
//            make.left.equalTo(100)
//            make.bottom.equalTo(-100)
//        }
//    }
//
//    @objc fileprivate func dismissAction() {
//        self.dismiss(animated: true, completion: nil)
//    }
//
//    override func animator() -> PresentationAnimator {
//        let animator = PresentationAnimator()
//        animator.startPosition = .outer(.left)
//        animator.endPosition = .inner(.center)
//        animator.animation = .normal
//        animator.transfers = [.alpha(from: 0, to: 1), .zoom(from: 0.3, to: 1)]
//        return animator
//    }
//}
