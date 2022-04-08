//
//  ListSectionControllerProvider.swift
//  ShiHuiFeiZhu
//
//  Created by Ming on 2021/5/24.
//

import Foundation
import IGListKit

public protocol ListSectionControllerProvider {
    /// 提供ListSectionController，注意ListSectonController会引用Section
    func sectionController() -> ListSectionController
}
