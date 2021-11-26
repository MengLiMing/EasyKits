//
//  ListBaseSection.swift
//  ShiHuiFeiZhu
//
//  Created by Ming on 2021/5/24.
//

import Foundation
import IGListKit
import Then
import RxSwift
import RxCocoa

extension ListBaseSection: Then { }
open class ListBaseSection: ListDiffable, ListBindingBaseSectionAPIProvider {
    open  var items: [ListBaseItem] = []
    
    open  var insets: UIEdgeInsets = .zero
    
    open  var minimumLineSpacing: CGFloat = 0
    
    open  var minimumInteritemSpacing: CGFloat = 0
    
    open  var header: ListBaseItem?
    
    open  var footer: ListBaseItem?
    
    open func diffIdentifier() -> NSObjectProtocol {
        return ObjectIdentifier(self).debugDescription as NSString
    }
    
    open func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
    
    public init() {}
    
    open func copySelf() -> ListBaseSection {
        return ListBaseSection().then {
            $0.items = items
            $0.insets = insets
            $0.minimumLineSpacing = minimumLineSpacing
            $0.minimumInteritemSpacing = minimumInteritemSpacing
            $0.header = header
            $0.footer = footer
        }
    }
}

public extension ListBaseSection {
    func add(_ item: ListBaseItem) {
        items.append(item)
    }
    
    @discardableResult
    func add(_ item: ListBaseItemProvider) -> ListBaseItem {
        let sectionItem = item.itemProvider
        items.append(sectionItem)
        return sectionItem
    }
    
    @discardableResult
    func add(_ items: [ListBaseItemProvider]) -> [ListBaseItem] {
        let sectionItems = items.map { $0.itemProvider }
        self.items += sectionItems
        return sectionItems
    }
    
    func setItems(_ items: [ListBaseItemProvider]) {
        self.items = items.map { $0.itemProvider }
    }
}

public extension Reactive where Base : ListBaseSection {
    ///  改变第几条 item，刷新Section
    var update: Binder<(Int,ListBaseItem)> {
        return Binder(base) { target, value in
            guard target.items.count > value.0 else {
                return
            }
            target.items[value.0] = value.1.copySelf()
            target.reloadSection(animated: false)
        }
    }
    
    var updateByIndex: Binder<Int> {
        return Binder(base) { target, index in
            guard target.items.count > index else {
                return
            }
            let item = target.items[index]
            target.items[index] = item.copySelf()
            target.reloadSection(animated: false)
        }
    }
    
    var updateData: Binder<(Int, ListBaseItemProvider)> {
        return Binder(base) { target, value in
            guard target.items.count > value.0 else {
                return
            }
            target.items[value.0] = value.1.itemProvider
            target.reloadSection(animated: false)
        }
    }
    
    /// 整个刷新
    var reloadSection: Binder<Void> {
        return Binder(base) { target, value in
            target.reloadSection(animated: false)
        }
    }
}

extension ListBaseSection : ReactiveCompatible {}
