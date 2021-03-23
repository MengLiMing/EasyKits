//
//  EasySegmentedCollectionView.swift
//  EasyKits
//
//  Created by 孟利明 on 2021/3/4.
//

import UIKit

public class EasySegmentedCollectionView: UICollectionView {
    public var indicatorView: EasySegmentedIndicatorBaseView? {
        willSet {
            indicatorView?.removeFromSuperview()
        }
        didSet {
            guard let indicatorView = indicatorView else {
                return
            }
            addSubview(indicatorView)
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let indicatorView = indicatorView, let backgroundView = backgroundView else {
            return
        }
        insertSubview(indicatorView, aboveSubview: backgroundView)
    }
}
