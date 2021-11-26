//
//  EasyCarouseCell.swift
//  EasyKits_Example
//
//  Created by 孟利明 on 2021/2/24.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import EasyKits

class EasyCarouseCell: EasyListViewCell {
    fileprivate lazy var carouseView: EasyCarouseView = {
        let v = EasyCarouseView(direction: .horizontal)
        v.carouseDataSource = self
        v.carouseDelegate = self
        v.collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "cell")
        return v
    }()
    
    fileprivate lazy var numLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 11)
        label.adjustsFontSizeToFitWidth = true
        label.backgroundColor = UIColor.black.withAlphaComponent(0.4)
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
        contentView.addSubview(carouseView)
        carouseView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        contentView.addSubview(numLabel)
        numLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(-10)
            maker.bottom.equalTo(-10)
            maker.height.equalTo(22)
        }
        numLabel.layer.cornerRadius = 11
        numLabel.layer.masksToBounds = true
    }
    
    var images: [String] {
        return self.cellModel?.data as? [String] ?? []
    }
    
    // MARK: Override
    override func bindCell(cellModel: EasyListCellModel) {
        if cellModel.isEqual(self.cellModel) { return }
        super.bindCell(cellModel: cellModel)
        
        self.carouseView.reloadData()
    }
    
    /// 可以根据数据计算高度 - 会缓存高度
    override class func cellHeight(cellModel: EasyListCellModel) -> CGFloat {
        return UIScreen.screenWidth
    }
}

extension EasyCarouseCell: EasyCarouseViewDelegate, EasyCarouseViewDataSource {
    func carouseView(_ carouseView: EasyCarouseView, cellForItemAt indexPath: IndexPath, itemIndex: Int) -> UICollectionViewCell {
        let cell = carouseView.collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as!
            ImageCell
        cell.imageView.kf.setImage(with: URL(string: images.element(itemIndex) ?? ""))
        return cell
    }
    
    func numberOfItems(in caroueView: EasyCarouseView) -> Int {
        return images.count
    }
    
    func carouseView(_ carouseView: EasyCarouseView, indexChanged index: Int) {
        self.numLabel.text = "    \(index + 1)/\(images.count)    "
    }
}

extension EasyCarouseCell {
    class ImageCell: UICollectionViewCell {
        let imageView = UIImageView()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            self.contentView.addSubview(imageView)
            imageView.snp.makeConstraints { (maker) in
                maker.edges.equalToSuperview()
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
