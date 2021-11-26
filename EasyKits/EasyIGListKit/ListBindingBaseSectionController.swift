//
//  ListBindingBaseSectionController.swift
//  ShiHuiFeiZhu
//
//  Created by Ming on 2021/5/24.
//

import Foundation
import IGListKit
import RxSwift
import RxCocoa

/// ListBaseSection可以实现此协议实现刷新功能
public protocol ListBindingBaseSectionAPIProvider: AnyObject {
}

private var listBindingSectionControllerKey: UInt8 = 0

extension ListBindingBaseSectionAPIProvider {
    /// 刷新的前提是 items Diff后 数据源有改变
    public func reloadSection(animated: Bool, completion: ((Bool) -> Void)? = nil) {
        bindingSectionController?.update(animated: animated, completion: completion)
    }
    
    public var section: Int? {
        self.bindingSectionController?.section
    }
    
    fileprivate var bindingSectionController: ListBindingBaseSectionController? {
        get {
            (objc_getAssociatedObject(self, &listBindingSectionControllerKey) as? WeakWrapper<ListBindingBaseSectionController>)?.obj
        }
        set {
            objc_setAssociatedObject(self, &listBindingSectionControllerKey, newValue == nil ? nil : WeakWrapper(newValue!), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}


open class ListBindingBaseSectionController: ListBindingSectionController<ListBaseSection> {
    public override init() {
        super.init()
        dataSource = self
        supplementaryViewSource = self
    }
    
    open override func didUpdate(to object: Any) {
        super.didUpdate(to: object)
        guard let section = self.object else {
            return
        }
        inset = section.insets
        minimumLineSpacing = section.minimumLineSpacing
        minimumInteritemSpacing = section.minimumInteritemSpacing
        section.bindingSectionController = self
    }
    
    open override func didSelectItem(at index: Int) {
        super.didSelectItem(at: index)
        guard let object = object,
              index >= 0,
              object.items.count > index else {
                  return
              }
        let item = object.items[index]
        item.selectedItem(section: object, index: index)
    }
}

extension ListBindingBaseSectionController: ListSupplementaryViewSource {
    public func supportedElementKinds() -> [String] {
        var kinds: [String] = []
        guard let object = self.object else { return kinds }
        if let _ = object.header {
            kinds.append(UICollectionView.elementKindSectionHeader)
        }
        if let _ = object.footer {
            kinds.append(UICollectionView.elementKindSectionFooter)
        }
        return kinds
    }
    
    public func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
        var view: ListBindableCell?
        if elementKind == UICollectionView.elementKindSectionHeader,
           let header = object?.header {
            view = collectionContext!.dequeueReusableSupplementaryView(ofKind: elementKind, for: self, class: header.itemType, at: index) as? ListBindableCell
            view?.bindViewModel(header)
        }
        if elementKind == UICollectionView.elementKindSectionFooter,
           let footer = object?.footer {
            view = collectionContext!.dequeueReusableSupplementaryView(ofKind: elementKind, for: self, class: footer.itemType, at: index) as? ListBindableCell
            view?.bindViewModel(footer)
        }
        
        return view ?? LisetBaseCollectionCell()
    }
    
    public func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
        if elementKind == UICollectionView.elementKindSectionHeader,
           let header = object?.header {
            return header.itemSize(self)
        }
        if elementKind == UICollectionView.elementKindSectionFooter,
           let footer = object?.footer {
            return footer.itemSize(self)
        }
        return .zero
    }
}

extension ListBindingBaseSectionController: ListBindingSectionControllerDataSource {
    public func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, viewModelsFor object: Any) -> [ListDiffable] {
        self.object?.items ?? []
    }
    
    public func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, cellForViewModel viewModel: Any, at index: Int) -> UICollectionViewCell & ListBindable {
        guard let viewModel = viewModel as? ListBaseItem else { return LisetBaseCollectionCell() }
        return collectionContext!.dequeueReusableCell(of: viewModel.itemType, for: self, at: index) as! (UICollectionViewCell & ListBindable)
    }
    
    public func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, sizeForViewModel viewModel: Any, at index: Int) -> CGSize {
        guard let viewModel = viewModel as? ListBaseItemSizeProvider else { return .zero }
        return viewModel.itemSize(self)
    }
}

public extension Reactive where Base: ListBindingBaseSectionController {
    var didSeletedItem: Signal<Int>{
        return methodInvoked(#selector(Base.didSelectItem(at:))).map{ return $0[0] as! Int }.asSignal(onErrorJustReturn: 0)
    }
}

