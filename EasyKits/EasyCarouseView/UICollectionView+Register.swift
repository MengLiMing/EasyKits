//
//  UICollectionView+Register.swift
//  EasyKits
//
//  Created by Ming on 2021/11/26.
//

import UIKit

public extension UICollectionView {
    private func identifier<T>(cellClass: T.Type) -> String {
        String(describing: cellClass)
    }
    
    func register<T: UICollectionViewCell>(cellClass: T.Type = T.self) {
        register(cellClass, forCellWithReuseIdentifier: identifier(cellClass: cellClass))
    }
    
    
    func dequeueReusableCell<T: UICollectionViewCell>(cellClass: T.Type = T.self, indexPath: IndexPath) -> T? {
        dequeueReusableCell(withReuseIdentifier: identifier(cellClass: cellClass), for: indexPath) as? T
    }
}
