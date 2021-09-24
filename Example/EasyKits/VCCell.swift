//
//  VCCell.swift
//  EasyKits_Example
//
//  Created by 孟利明 on 2021/2/5.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import EasyKits

class VCCell: EasyListViewCell {
    fileprivate lazy var contentLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.contentLabel)
        self.contentLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.left.equalTo(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var data: ViewController.Demo? {
        return self.cellModel?.data as? ViewController.Demo
    }
    
    override func bindCell(cellModel: EasyListCellModel) {
        if cellModel.isEqual(self.cellModel) { return }
        super.bindCell(cellModel: cellModel)
        self.contentLabel.text = data?.data.title
    }
    
    override class func cellHeight(cellModel: EasyListCellModel) -> CGFloat {
        return 60
    }
}
