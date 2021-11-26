//
//  EasyCarouseViewLayout.swift
//  EasyKits
//
//  Created by Ming on 2021/11/25.
//

import Foundation

final class EasyCarouseViewLayout: UICollectionViewFlowLayout {
    /// 宽高的比例 - 滑动时的缩放比例 0 - 1
    let transformScale: CGFloat
    /// 透明度比例 0 - 1
    let alphaScale: CGFloat
    
    /// 间隔
    let itemSpace: CGFloat
    
    
    init(transformScale: CGFloat, alphaScale: CGFloat, itemSpace: CGFloat) {
        self.transformScale = max(0, min(1, transformScale))
        self.alphaScale = max(0, min(1, alphaScale))
        self.itemSpace = itemSpace
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        
        switch self.scrollDirection {
        case .vertical:
            let space = itemSize.height/2 * (1 - transformScale)
            let resultSpace = -space + itemSpace
            self.minimumLineSpacing = resultSpace
        case .horizontal:
            let space = itemSize.width/2 * (1 - transformScale)
            let resultSpace = -space + itemSpace
            self.minimumLineSpacing = resultSpace
        @unknown default:
            break
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributesArray = NSArray(array: super.layoutAttributesForElements(in: rect) ?? [], copyItems: true) as? [UICollectionViewLayoutAttributes] ?? []
        for attributes in attributesArray {
            if rect.intersects(attributes.frame) {
                dealAttributes(attributes)
            }
        }
        return attributesArray
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes
        if let attributes = attributes {
            dealAttributes(attributes)
        }
        return attributes
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else {
            return proposedContentOffset
        }
        var targetPoint = proposedContentOffset

        /// 本身要停止时的rect
        let proposedRect = CGRect(x: proposedContentOffset.x,
                                  y: proposedContentOffset.y,
                                  width: collectionView.bounds.size.width,
                                  height: collectionView.bounds.size.height)
        let items = layoutAttributesForElements(in: proposedRect) ?? []
        switch self.scrollDirection {
        case .horizontal:
            let centerX = proposedRect.midX
            /// 计算屏幕内item离中心的最小距离
            var minSpace: CGFloat?
            items.forEach { attributes in
                let itemSpace = attributes.center.x - centerX
                if let space = minSpace {
                    if abs(itemSpace) < abs(space) {
                        minSpace = itemSpace
                    }
                } else {
                    minSpace = itemSpace
                }
            }
            if let minSpace = minSpace,
               proposedContentOffset.x > 0 && proposedContentOffset.x < collectionViewContentSize.width - collectionView.bounds.width {
                targetPoint.x += minSpace
            }
        case .vertical:
            let centerY = proposedRect.midY
            /// 计算屏幕内item离中心的最小距离
            var minSpace: CGFloat?
            items.forEach { attributes in
                let itemSpace = attributes.center.y - centerY
                if let space = minSpace {
                    if abs(itemSpace) < abs(space) {
                        minSpace = itemSpace
                    }
                } else {
                    minSpace = itemSpace
                }
            }

            if let minSpace = minSpace,
               proposedContentOffset.y > 0 && proposedContentOffset.y < collectionViewContentSize.height - collectionView.bounds.height {
                targetPoint.y += minSpace
            }
        @unknown default:
            break
        }
        return targetPoint
    }
}

extension EasyCarouseViewLayout {
    func dealAttributes(_ attributes: UICollectionViewLayoutAttributes) {
        guard let collectionView = collectionView else {
            return
        }
        
        let center = attributes.center
        switch self.scrollDirection {
        case .horizontal:
            let centerX = collectionView.contentOffset.x + collectionView.bounds.width/2
            
            let maxSpace = attributes.size.width * (1 + transformScale)/2
            let space = abs(center.x - centerX)
            let progress = min(maxSpace, space)/maxSpace

            let scale = 1 - progress * (1 - transformScale)
            
            attributes.transform = .init(scaleX: scale, y: scale)
            
            let alpha = 1 - progress * (1 - alphaScale)
            attributes.alpha = alpha
        case .vertical:
            let centerY = collectionView.contentOffset.y + collectionView.bounds.height/2
            
            let maxSpace = attributes.size.height * (1 + transformScale)/2
            let space = abs(center.y - centerY)
            let progress = min(maxSpace, space)/maxSpace

            let scale = 1 - progress * (1 - transformScale)
            attributes.transform = .init(scaleX: scale, y: scale)
            
            let alpha = 1 - progress * (1 - alphaScale)
            attributes.alpha = alpha
        @unknown default:
            break
        }
    }
}
