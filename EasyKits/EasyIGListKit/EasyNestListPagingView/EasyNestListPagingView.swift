//
//  EasyNestListPagingView.swift
//  EasyKits
//
//  Created by Ming on 2021/11/26.
//

import Foundation
import IGListKit
import RxSwift
import RxCocoa
import Then

/// 头部数据源
public protocol EasyNestListPagingViewDataSource: AnyObject {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable]
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController
}

public final class EasyNestListPagingView: UICollectionView {

    /// 刷新样式
    public typealias RefreshType = SyncScrollContext.RefreshType
    
    private let disposeBag = DisposeBag()
    
    public weak var nestDataSource: EasyNestListPagingViewDataSource?
    
    /// container背景色设置
    public var containerBackgroundColor: UIColor? {
        didSet {
            containerSection.itemBackgroundColor.onNext(containerBackgroundColor)
        }
    }
    
    /// 刷新样式
    public var refreshStyle: RefreshType {
        set {
            syncContext.refreshType = newValue
        }
        
        get {
            syncContext.refreshType
        }
    }

    /// 是否悬停信号
    public var isHoverChanged: Driver<Bool> {
        return syncContext.isHoverChanged
    }
    
    public var pagingContainer: EasyNestListPagingContainer? {
        didSet {
            pagingContainerChanged()
        }
    }
    
    public private(set) lazy var adapter = ListAdapter(
        updater: ListAdapterUpdater(),
        viewController: nil
    ).then {
        $0.dataSource = self
        $0.collectionView = self
    }
    
    private lazy var contentSizeChanged: Driver<CGSize> = {
        rx.kvo_contentSize
            .distinctUntilChanged()
            .asDriver(onErrorDriveWith: .empty())
    }()
    
    private lazy var syncContext: SyncScrollContext = {
        let context = SyncScrollContext()
        context.outerItem = self
        return context
    }()
    
    private lazy var containerSection: ContainerSection = .init()
    
    public convenience init() {
        self.init(frame: .zero, collectionViewLayout: ListCollectionViewLayout(stickyHeaders: false, scrollDirection: .vertical, topContentInset: 0, stretchToEdge: false))
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        backgroundColor = UIColor.white
        if #available(iOS 10.0, *) {
            isPrefetchingEnabled = false
        }
        keyboardDismissMode = .onDrag
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        bind()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        self.contentSizeChanged
            .drive(onNext: { [weak self] contentSize in
                guard let self = self else {
                    return
                }
                self.configSyncContextOffset(contentSize: contentSize)
            })
            .disposed(by: disposeBag)
    }
    
    private func configSyncContextOffset(contentSize: CGSize) {
        syncContext.maxOffsetY = contentSize.height - bounds.size.height
        containerSection.containerHeight.onNext(bounds.size.height)
    }
    
    fileprivate func pagingContainerChanged() {
        if let container = pagingContainer {
            container.innerScrollChangeHandler = {[weak self] item in
                self?.syncContext.innerItem = item
            }
            self.syncContext.containerView = container.horizontalScrollView
            containerSection.containerView.onNext(container.nestContentView)
        } else {
            containerSection.containerHeight.onNext(0)
            containerSection.containerView.onNext(nil)
            syncContext.outerItem = nil
            syncContext.innerItem = nil
            syncContext.containerView = nil
        }
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        } else {
            var nextResponder = self.next
            while nextResponder != nil {
                if let viewController = nextResponder as? UIViewController {
                    viewController.automaticallyAdjustsScrollViewInsets = false
                    break
                }
                nextResponder = nextResponder?.next
            }
        }
        self.adapter.performUpdates(animated: false, completion: nil)
    }
}

extension EasyNestListPagingView: ListAdapterDataSource {
    public func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        (nestDataSource?.objects(for: listAdapter) ?? []) + [containerSection]
    }
    
    public func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        guard let object = object as? ListSectionControllerProvider else {
            return nestDataSource?.listAdapter(listAdapter, sectionControllerFor: object) ?? ListSectionController()
        }
        return object.sectionController()
    }
    
    public func emptyView(for listAdapter: ListAdapter) -> UIView? {
        nil
    }
}

extension EasyNestListPagingView: SyncOuterScroll, UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        wrapGestureRecognizer(gestureRecognizer, shouldRecognizeSimultaneouslyWith: otherGestureRecognizer)
    }
}


fileprivate extension EasyNestListPagingView {
    class ContainerSection: ListBaseSection, ListSectionControllerProvider {
        
        let disposeBag = DisposeBag()
        
        /// 高度变化
        let containerHeight: PublishSubject<CGFloat> = .init()
        
        /// 子视图变化
        let containerView: PublishSubject<UIView?> = .init()
        
        /// 背景色
        let itemBackgroundColor: PublishSubject<UIColor?> = .init()

        private lazy var containerItem: ListBaseItem = .init(data: containerData)
        
        private lazy var containerData: ContainerItem = .init()
        
        private weak var _sectionController: ListSectionController?
        
        override init() {
            super.init()
            
            self.add(containerItem)
            
            bind()
        }
        
        func bind() {
            containerHeight
                .distinctUntilChanged()
                .subscribe(onNext: { [weak self] height in
                    self?.heightChange(height)
                })
                .disposed(by: disposeBag)
            
            containerView
                .bind(to: self.containerData.containerView)
                .disposed(by: disposeBag)
            
            itemBackgroundColor
                .bind(to: containerData.backgroundColor)
                .disposed(by: disposeBag)
        }
        
        fileprivate func heightChange(_ height: CGFloat) {
            guard let sectionController = self._sectionController else {
                return
            }
            containerItem.itemSize = nil
            containerData.height.accept(height)
            sectionController.collectionContext?.invalidateLayout(for: sectionController, completion: nil)
        }
        
        func sectionController() -> ListSectionController {
            let sectionController = ListBindingBaseSectionController()
            self._sectionController = sectionController
            return sectionController
        }
    }
    
    class ContainerItem: ListBaseItemDataType {
        var itemType: ListBindableCell.Type = ContainerCell.self
        
        let backgroundColor: BehaviorRelay<UIColor?> = .init(value: .white)
        
        let height: BehaviorRelay<CGFloat> = .init(value: 0)
        
        let containerView: BehaviorRelay<UIView?> = .init(value: nil)
        
        func itemSize(_ sectionController: ListSectionController) -> CGSize {
            return .init(width: sectionController.contentWidth, height: height.value)
        }
    }
    
    class ContainerCell: ListBaseBindableDataCell<ContainerItem> {
        private weak var containerView: UIView? {
            didSet {
                guard let containerView = containerView else {
                    oldValue?.removeFromSuperview()
                    return
                }
                if containerView != oldValue {
                    self.contentView.addSubview(containerView)
                    oldValue?.removeFromSuperview()
                    containerView.snp.remakeConstraints { maker in
                        maker.edges.equalToSuperview()
                    }
                }
            }
        }
        
        
        
        override func bindData(_ data: EasyNestListPagingView.ContainerItem) {
            data.containerView
                .observe(on: MainScheduler.asyncInstance)
                .subscribe(onNext: { [weak self] containerView in
                    self?.containerView = containerView
                })
                .disposed(by: bindDisposeBag)
            
            data.backgroundColor
                .bind(to: rx.backgroundColor, contentView.rx.backgroundColor)
                .disposed(by: bindDisposeBag)
        }
    }
}
