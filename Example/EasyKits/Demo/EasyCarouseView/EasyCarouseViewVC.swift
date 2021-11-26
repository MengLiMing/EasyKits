//
//  EasyCarouseViewVC.swift
//  EasyKits_Example
//
//  Created by 孟利明 on 2021/2/24.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import EasyKits
import Kingfisher
import Then

class EasyCarouseViewVC: UIViewController {
    fileprivate let carouseView1 = CarouseImageView(
        direction: .horizontal,
        transformScale: 0.9,
        alphaScale: 0.3,
        itemSpace: 10,
        itemWidthScale: 0.8,
        itemHeightScale: 1).then {
            $0.carouseView.status = .auto(3, false)
        }
    fileprivate let carouseView2 = CarouseImageView(
        direction: .vertical,
        transformScale: 0.9,
        alphaScale: 0.3,
        itemSpace: 0,
        itemWidthScale: 1,
        itemHeightScale: 0.8)
    fileprivate let carouseView3 = CustomCarouseView().then {
        $0.status = .loop
    }
    fileprivate let carouseView4 = NewsCarouseView().then {
        $0.status = .auto(4, true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "轮播"
        setSubviews()
    }
    
    fileprivate func setSubviews() {
        /// 图片轮播
        self.view.addSubview(carouseView1)
        carouseView1.snp.makeConstraints { (maker) in
            maker.top.equalTo(UIScreen.navigationHeight)
            maker.left.right.equalTo(0)
            maker.height.equalTo(150)
        }
        
        self.view.addSubview(carouseView2)
        carouseView2.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.carouseView1.snp.bottom).offset(10)
            maker.left.right.equalTo(0)
            maker.height.equalTo(150)
        }
        
        self.view.addSubview(carouseView3)
        carouseView3.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.carouseView2.snp.bottom).offset(10)
            maker.left.right.equalTo(0)
            maker.height.equalTo(150)
        }
        
        self.view.addSubview(carouseView4)
        carouseView4.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.carouseView3.snp.bottom).offset(10)
            maker.left.right.equalTo(0)
            maker.height.equalTo(28)
        }
    }
    
}

/// 图片轮播
class CarouseImageView: UIView, EasyCarouseViewDelegate, EasyCarouseViewDataSource {
    lazy var carouseView: EasyCarouseView = {
        let v = EasyCarouseView(direction: direction,
                                transformScale: transformScale,
                                alphaScale: alpha,
                                itemSpace: itemSpace,
                                itemWidthScale: itemWidthScale,
                                itemHeightScale: itemHeightScale)
        v.status = .auto(3)
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
    
    fileprivate let images = [
        "http://img.alicdn.com/imgextra/i1/2200651898605/O1CN01yW9TI92DR8nmDzDRB_!!0-item_pic.jpg",
        "http://img.alicdn.com/imgextra/i2/2200651898605/O1CN01Vs5Kvv2DR8nd6Aic5_!!2200651898605.jpg",
        "http://img.alicdn.com/imgextra/i1/2200651898605/O1CN01sYPHkO2DR8ngh8VyX_!!2200651898605.jpg",
        "http://img.alicdn.com/imgextra/i2/2200651898605/O1CN01UNUUWo2DR8ndI121x_!!2200651898605.jpg",
        "http://img.alicdn.com/imgextra/i3/2200651898605/O1CN01uOSkFx2DR8nheyhel_!!2200651898605.jpg"
    ]
    
    fileprivate let direction: EasyCarouseView.Direction
    
    let transformScale: CGFloat
    let alphaScale: CGFloat
    let itemSpace: CGFloat
    let itemWidthScale: CGFloat
    let itemHeightScale: CGFloat
    
    init(direction: EasyCarouseView.Direction,
         transformScale: CGFloat = 1,
         alphaScale: CGFloat = 1,
         itemSpace: CGFloat = 0,
         itemWidthScale: CGFloat = 1,
         itemHeightScale: CGFloat = 1) {
        self.direction = direction
        self.transformScale = transformScale
        self.alphaScale = alphaScale
        self.itemSpace = itemSpace
        self.itemWidthScale = itemWidthScale
        self.itemHeightScale = itemHeightScale
        super.init(frame: .zero)
        
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        
        self.addSubview(carouseView)
        carouseView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        
        self.addSubview(numLabel)
        numLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(-10)
            maker.bottom.equalTo(-10)
            maker.height.equalTo(22)
        }
        
        addSubview(UIView().then {
            $0.backgroundColor = .red
        }) { maker in
            maker.leading.trailing.equalTo(0)
            maker.centerY.equalToSuperview()
            maker.height.equalTo(1)
        }
        
        addSubview(UIView().then {
            $0.backgroundColor = .red
        }) { maker in
            maker.top.bottom.equalTo(0)
            maker.centerX.equalToSuperview()
            maker.width.equalTo(1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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

/// 自定义轮播view
class CustomCarouseView: EasyCarouseView, EasyCarouseViewDelegate, EasyCarouseViewDataSource {
    class CustomCarouseCell: UICollectionViewCell {
        fileprivate let l1: UILabel =  UILabel()
        let l2: UILabel =  UILabel()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.backgroundColor = .gray
            l1.text = "自定义轮播"
            addSubview(l1)
            l1.snp.makeConstraints { (maker) in
                maker.centerX.equalToSuperview()
                maker.top.equalTo(20)
            }
            
            addSubview(l2)
            l2.snp.makeConstraints { (maker) in
                maker.center.equalToSuperview()
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    init() {
        super.init(direction: .horizontal, transformScale: 0.9, alphaScale: 0.4, itemSpace: 5, itemWidthScale: 0.85, itemHeightScale: 1)
        self.status = .none
        self.carouseDataSource = self
        self.carouseDelegate = self
        self.collectionView.register(CustomCarouseCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func carouseView(_ carouseView: EasyCarouseView, cellForItemAt indexPath: IndexPath, itemIndex: Int) -> UICollectionViewCell {
        let cell = carouseView.collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as!
        CustomCarouseCell
        cell.l2.text = "下标：\(itemIndex)"
        return cell
    }
    
    func numberOfItems(in caroueView: EasyCarouseView) -> Int {
        return 3
    }
}

/// 广告播报
class NewsCarouseView: EasyCarouseView, EasyCarouseViewDelegate, EasyCarouseViewDataSource {
    class CustomCarouseCell: UICollectionViewCell {
        fileprivate lazy var bgView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.black.withAlphaComponent(0.45)
            return view
        }()
        
        fileprivate lazy var iconImageView: UIImageView = {
            let view = UIImageView()
            view.kf.setImage(with: URL(string: "https://ss1.baidu.com/6ON1bjeh1BF3odCf/it/u=1930835780,4092337419&fm=15&gp=0.jpg"))
            return view
        }()
        
        fileprivate lazy var contentLabel: UILabel = {
            let label = UILabel()
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 12)
            return label
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.backgroundColor = .clear
            self.contentView.backgroundColor = .clear
            setSubviews()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        fileprivate func setSubviews() {
            contentView.addSubview(bgView)
            bgView.snp.makeConstraints { (maker) in
                maker.left.top.bottom.equalTo(0)
                maker.right.lessThanOrEqualTo(0)
            }
            self.bgView.layer.cornerRadius = 14
            
            bgView.addSubview(iconImageView)
            iconImageView.snp.makeConstraints { (maker) in
                maker.left.equalTo(3)
                maker.centerY.equalToSuperview()
                maker.width.height.equalTo(22)
            }
            self.iconImageView.layer.cornerRadius = 11
            self.iconImageView.layer.masksToBounds = true
            
            bgView.addSubview(contentLabel)
            contentLabel.snp.makeConstraints { (maker) in
                maker.left.equalTo(self.iconImageView.snp.right).offset(5)
                maker.centerY.equalToSuperview()
                maker.right.equalTo(-10)
            }
        }
    }
    
    init() {
        super.init(direction: .vertical)
        self.carouseDataSource = self
        self.carouseDelegate = self
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = false
        collectionView.register(cellClass: CustomCarouseCell.self)
    }
    
    fileprivate let names = ["刚刚好", "MengLiMing", "一个幸运的用户"]
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func carouseView(_ carouseView: EasyCarouseView, cellForItemAt indexPath: IndexPath, itemIndex: Int) -> UICollectionViewCell {
        let cell = carouseView.collectionView.dequeueReusableCell(cellClass: CustomCarouseCell.self, indexPath: indexPath)!
        cell.contentLabel.text = (names.element(itemIndex) ?? "") + "抽中了一等奖"
        return cell
    }
    
    func numberOfItems(in caroueView: EasyCarouseView) -> Int {
        return names.count
    }
}

import SnapKit
extension UIView {
    func addSubview(_ view: UIView, layout: (ConstraintMaker) -> Void) {
        addSubview(view)
        view.snp.makeConstraints(layout)
    }
}
