//
//  ListCollectionContext+Ex.swift
//  EasyKits
//
//  Created by Ming on 2021/11/8.
//

import Foundation
import IGListKit

public extension ListCollectionContext {
    func dequeue<T: ListBindable>(reusableCellOf cellClass: T.Type = T.self, for sectionController: ListSectionController, at index: Int) -> T where T: UICollectionViewCell {
        return dequeueReusableCell(of: cellClass, for: sectionController, at: index) as! T
    }
}
