//
//  EasyListPriceCell.swift
//  EasyKits_Example
//
//  Created by 孟利明 on 2021/2/24.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import EasyKits

class EasyListPriceCell: EasyListViewCell {
    fileprivate lazy var bgImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "price_bg"))
        return view
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 10)
        label.text = "券后价"
        return label
    }()
    
    fileprivate lazy var priceLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setSubviews() {
        contentView.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(12)
            maker.top.equalTo(9)
            maker.height.equalTo(14)
        }
        
        contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(12)
            maker.top.equalTo(self.titleLabel.snp.bottom)
            maker.height.equalTo(33)
        }
    }
    
    // MARK: Override
    override func bindCell(cellModel: EasyListCellModel) {
        if cellModel.isEqual(self.cellModel) { return }
        super.bindCell(cellModel: cellModel)
        
        /// 实际开发中去cellModel.data 数据源显示
        self.priceLabel.attributedText = self.priceAttr()
    }
    
    fileprivate func priceAttr() -> NSAttributedString {
        return "￥".attributes {
            $0.font(UIFont.systemFont(ofSize: 18, weight: .medium))
                .textColor(UIColor.white)
        } + "24.5".attributes {
            $0.font(UIFont.systemFont(ofSize: 24, weight: .medium))
                .textColor(UIColor.white)
        } + "  ".attribute
        + "¥29.9".attributes {
            $0.font(UIFont.systemFont(ofSize: 14))
                .textColor(UIColor.hex("#eeeeee"))
                .strikethrough(.styleSingle, color: UIColor.hex("#eeeeee"))
                .baselineOffset(1)
        }
        
    }
    
    override class func cellHeight(cellModel: EasyListCellModel) -> CGFloat {
        return 64
    }
}
