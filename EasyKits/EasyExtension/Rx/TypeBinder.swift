//
//  TypeBinder.swift
//  EasyKits
//
//  Created by Ming on 2021/11/26.
//

import Foundation
import RxSwift

public struct TypeBinder<Value>: ObserverType {
    public typealias Element = Value
    
    private let binding: (Event<Value>) -> Void


    public init<Target>(_ targetType: Target.Type, scheduler: ImmediateSchedulerType = MainScheduler(), binding: @escaping (Target.Type, Value) -> Void) {

        self.binding = { event in
            switch event {
            case .next(let element):
                _ = scheduler.schedule(element) { element in
                    binding(targetType, element)
                    return Disposables.create()
                }
            case .error, .completed:
                break
            }
        }
    }

    /// Binds next element to owner view as described in `binding`.
    public func on(_ event: Event<Value>) {
        self.binding(event)
    }

    /// Erases type of observer.
    ///
    /// - returns: type erased observer.
    public func asObserver() -> AnyObserver<Value> {
        AnyObserver(eventHandler: self.on)
    }
}
