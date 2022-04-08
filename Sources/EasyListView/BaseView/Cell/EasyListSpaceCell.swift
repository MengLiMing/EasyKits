//
//  EasyListSpaceCell.swift
//  EasyKit
//
//  Created by 孟利明 on 2020/6/28.
//

import UIKit

public final class EasyListSpaceCell: EasyListViewCell {
    public override class func cellHeight(cellModel: EasyListCellModel) -> CGFloat {
        guard let model = cellModel.data as? EasyListSpaceModelProtocol else {
            return 0
        }
        return model.pSpaceHeight
    }
    
    public override func bindCell(cellModel: EasyListCellModel) {
        super.bindCell(cellModel: cellModel)
        guard let model = cellModel.data as? EasyListSpaceModelProtocol else {
            return
        }
        self.contentView.backgroundColor = model.pSpaceColor
    }
}

public protocol EasyListSpaceModelProtocol {
    var pSpaceHeight: CGFloat { get }
    var pSpaceColor: UIColor? { get }
}

public final class EasyListSpaceDataModel: NSObject, EasyListSpaceModelProtocol {
    public var pSpaceHeight: CGFloat
    
    public var pSpaceColor: UIColor?
    
    public init(height: CGFloat, color: UIColor?) {
        self.pSpaceHeight = height
        self.pSpaceColor = color
        super.init()
    }
}

public extension EasyListSpaceDataModel {
    class func spaceCellModel(height: CGFloat = 0, color: UIColor? = .clear) -> EasyListCellModel {
        let spaceModel = EasyListSpaceDataModel(height: height, color: color)
        let cellModel = EasyListCellModel(cellType: EasyListSpaceCell.self, data: spaceModel)
        return cellModel
    }
    
    class func spaceSectionModel(height: CGFloat = 0, color: UIColor? = .clear) -> EasyListSectionModel {
        let sectionModel = EasyListSectionModel()
        sectionModel.add(cellModel: spaceCellModel(height: height, color: color))
        return sectionModel
    }
}

public extension EasyListCellModel {
    class func spaceCellModel(height: CGFloat = 0, color: UIColor? = .clear) -> EasyListCellModel {
        return EasyListSpaceDataModel.spaceCellModel(height: height, color: color)
    }
}

public extension EasyListSectionModel {
    class func spaceSectionModel(height: CGFloat = 0, color: UIColor? = .clear) -> EasyListSectionModel {
        return EasyListSpaceDataModel.spaceSectionModel(height: height, color: color)
    }
    
    func addSpace(height: CGFloat = 0, color: UIColor? = .clear) {
        self.add(cellModel: EasyListCellModel.spaceCellModel(height: height, color: color))
    }
}
