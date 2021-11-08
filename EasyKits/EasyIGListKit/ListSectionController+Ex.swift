//
//  ListSectionController+Ex.swift
//  EasyKits
//
//  Created by Ming on 2021/11/4.
//

import Foundation
import IGListKit

public extension ListSectionController {
    var contentWidth: CGFloat {
        guard let collectionContext = collectionContext else {
            return 0
        }
        return collectionContext.containerSize.width - (inset.left + inset.right)
    }
}
