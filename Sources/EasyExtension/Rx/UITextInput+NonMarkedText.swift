//
//  UITextInput+NonMarkedText.swift
//  EasyKits
//
//  Created by Ming on 2021/11/26.
//

import UIKit
import RxSwift
import RxCocoa

public extension UITextInput {
    /// 非高亮的文字
    var nonMarkedText: String? {
        let start = beginningOfDocument
        let end = endOfDocument

        guard let rangeAll = textRange(from: start, to: end),
            let text = text(in: rangeAll) else {
                return nil
        }

        guard let markedTextRange = markedTextRange else {
            return text
        }

        guard let startRange = textRange(from: start, to: markedTextRange.start),
              let endRange = textRange(from: markedTextRange.end, to: end) else {
            return text
        }
        return (self.text(in: startRange) ?? "") + (self.text(in: endRange) ?? "")
    }
}

public extension Reactive where Base: UITextField {
    var nonMarkedText: Observable<String?> {
        return base.rx
            .text
            .withLatestFrom(Observable.just(base)) { $1.nonMarkedText }
    }
}

public extension Reactive where Base: UITextView {
    var nonMarkedText: Observable<String?> {
        return base.rx
            .text
            .withLatestFrom(Observable.just(base)) { $1.nonMarkedText }
    }
}
