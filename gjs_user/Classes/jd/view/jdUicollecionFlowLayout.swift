//
//  jdUicollecionFlowLayout.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/11/22.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

class jdUicollecionFlowLayout: UICollectionViewFlowLayout {
    open var itemCountPerRow: Int = 0
       open var rowCount: Int = 0
       open var allAttributes: [UICollectionViewLayoutAttributes] = []
       
       override func prepare() {
           super.prepare()
           self.rowCount = 2
           self.itemCountPerRow = 5
           self.allAttributes = [UICollectionViewLayoutAttributes]()
           
           let count: Int = (self.collectionView?.numberOfItems(inSection: 0))!
           for i in 0...count-1 {
               let indexPath = IndexPath(item: i, section: 0)
               let array = self.layoutAttributesForItem(at: indexPath)
               self.allAttributes.append(array!)
           }
       }
       
       override var collectionViewContentSize: CGSize {
           return super.collectionViewContentSize
       }
       
       override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
           let item = indexPath.item
           var x: Int? = 0
           var y: Int? = 0
           self.targetPositionWithItem(item: item, resultX: &x, resultY: &y)
           let item2 = self.originItemAtX(x: x!, y: y!)
           let theNewIndexPath = IndexPath(item: item2, section: indexPath.section)
           let theNewAttr = super.layoutAttributesForItem(at: theNewIndexPath)
           theNewAttr?.indexPath = indexPath
           return theNewAttr
       }
       
       override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
           let attributes = super.layoutAttributesForElements(in: rect)
           var tmp = [UICollectionViewLayoutAttributes]()
           for attr in attributes! {
               for attr2 in self.allAttributes {
                   if attr.indexPath.item == attr2.indexPath.item {
                       tmp.append(attr2)
                       break
                   }
               }
           }
           return tmp
       }
       
       // 根据item 计算目标item的位置
       // x 横向偏移 y竖向偏移
       func targetPositionWithItem(item: Int, resultX x: inout Int?, resultY y: inout Int?) {
           let page = item / (self.itemCountPerRow * self.rowCount)
           let theX = item % self.itemCountPerRow + page * self.itemCountPerRow
           let theY = item / self.itemCountPerRow - page * self.rowCount
           if x != nil {
               x = theX
           }
           if y != nil {
               y = theY
           }
       }
       
       // 根据偏移量计算item
       func originItemAtX(x: Int, y: Int) -> Int {
           let item = x * self.rowCount + y
           return item
       }
}
