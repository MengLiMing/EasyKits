//
//  ListBaseItem+Provider.swift
//  EasyKits
//
//  Created by zkkj on 2021/11/4.
//

import Foundation
import IGListKit
import RxSwift
import RxCocoa

private struct AssociateKey {
    static var list_item_selected_event_Clousure: UInt8 = 0
    static var list_item_selected_handler_Clousure: UInt8 = 0
    static var list_item_selected_event_observable: UInt8 = 0
}

// MARK: 提供cell
public protocol ListBaseItemTypeProvider {
    var itemType: ListBindableCell.Type { get }
}


// MARK: 提供点击事件
public protocol ListBaseItemSelectionHandlerProvider: AnyObject {
    typealias SelectedItem = (section: ListBaseSection, listItem: ListBaseItem, data: ListBaseItemDataType, index: Int)
    typealias SelectedHandler = (SelectedItem) -> Void
    
    var itemSelectedHandler: SelectedHandler?  { get set }
}

extension ListBaseItemSelectionHandlerProvider {
    var _itemSeletedEventClosure: SelectedHandler?  {
        get {
            objc_getAssociatedObject(self, &AssociateKey.list_item_selected_event_Clousure) as? SelectedHandler
        }
        
        set {
            objc_setAssociatedObject(self, &AssociateKey.list_item_selected_event_Clousure, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    public var itemSelectedHandler: SelectedHandler?  {
       get {
           objc_getAssociatedObject(self, &AssociateKey.list_item_selected_handler_Clousure) as? SelectedHandler
       }
       
       set {
           objc_setAssociatedObject(self, &AssociateKey.list_item_selected_handler_Clousure, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
       }
   }
    
    public var selectedEvent: ControlEvent<SelectedItem> {
        if let source = objc_getAssociatedObject(self, &AssociateKey.list_item_selected_event_observable) as? Observable<SelectedItem> {
            return .init(events: source)
        }
        let source = Observable<SelectedItem>.create({ [weak self] observer in
            self?._itemSeletedEventClosure = { selectedItem in
                observer.onNext(selectedItem)
            }
            return Disposables.create()
        })
        .share()
        
        objc_setAssociatedObject(self, &AssociateKey.list_item_selected_event_observable, source, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return .init(events: source)
    }
}

// MARK: 提供分割线样式
public protocol ListBaseItemSeparatorStyleProvider {
    var separatorStyle: ListItemSeparatorStyle { get set }
}


// MARK: 提供cell size
public protocol ListBaseItemSizeProvider {
    func itemSize(_ sectionController: ListSectionController) -> CGSize
}

// MARK: 提供ListBaseItem
public protocol ListBaseItemProvider {
    var itemProvider: ListBaseItem { get }
}

public extension ListBaseItemProvider where Self: ListBaseItemDataType {
    var itemProvider: ListBaseItem {
        return ListBaseItem(data: self)
    }
}
