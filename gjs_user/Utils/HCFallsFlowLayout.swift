//
//  HCFallsFlowLayout.swift
//  MedicineLog
//
//  Created by 刘春奇 on 2019/3/1.
//  Copyright © 2019 com.nsqk.chunqi.liu. All rights reserved.
//

import UIKit



let ScreenWidth = UIScreen.main.bounds.size.width

let ScreenHight = UIScreen.main.bounds.size.height


/// 返回每个item高度的代理
protocol WaterflowLayoutDelegate: class {
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat
}


class HCFallsFlowLayout: UICollectionViewFlowLayout {

    //返回item高度的代理
    weak var delegate: WaterflowLayoutDelegate?
    

    
    //item 的 attribute 数组
    var itemAttributes = [UICollectionViewLayoutAttributes]()

    //列的高度 数组
    var sumYHeights = [CGFloat]()
    
    //默认列数
    var columCount = 2
    
    var contentHeight : CGFloat = 0
    
    
    
    
    //默认参数
    
    var edgeInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    var lineSpacing : CGFloat = 5.0
    
    var interitemSpacing : CGFloat = 5.0
    
    

    
    
    ///初始化一些参数 行高 列宽 edgeinset
    func basicSetting()  {
        self.minimumLineSpacing = CGFloat(self.lineSpacing)
        self.minimumInteritemSpacing = CGFloat(self.interitemSpacing)
        self.sectionInset = self.edgeInset
        
    }
    
    
    override var collectionViewContentSize: CGSize{
        return CGSize(width: self.collectionView!.bounds.width, height: contentHeight + self.edgeInset.bottom)
    }
    
    
    override func prepare() {
        super.prepare()

        guard columCount > 0, let collectionView = collectionView else {
            return
        }
        
        
        //移除所有列的高度
        self.sumYHeights.removeAll()
        
        //移除所有item的attribute
        self.itemAttributes.removeAll()
        
        //先填充所有列第一行元素
        sumYHeights = Array(repeating: self.edgeInset.top
            , count: self.columCount)
        
        //获取section为0的所有item（或者为cell）的个数
        let itemsCount = collectionView.numberOfItems(inSection: 0)
        
        //添加所有的item attribute
        for i in 0..<itemsCount {
            //获取每个item的 attribute
            let indexPath = IndexPath(item: i, section: 0)
            
            guard let attribute = layoutAttributesForItem(at: indexPath) else {
                continue
            }
            self.itemAttributes.append(attribute)

        }
        
    }


    
    
}



extension HCFallsFlowLayout : UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    /*
     
     会先调用 layoutAttributesForItem
     后调用 layoutAttributesForElements
     
     */

    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

        guard let delegate = delegate, columCount > 0 else{
            return nil
        }
        
        //先找到sum高度最小的列
        let minHeight = sumYHeights.min()!
        let minColumn = sumYHeights.index(of: minHeight)!
        
        //计算item 大小
        let width: CGFloat = (collectionView!.frame.size.width - self.edgeInset.left - self.edgeInset.right - CGFloat(columCount - 1) * self.interitemSpacing) / CGFloat(columCount)
        
        let height: CGFloat = delegate.collectionView(collectionView!, heightForItemAt: indexPath)

        let x : CGFloat = self.edgeInset.left + (width + interitemSpacing) * CGFloat(minColumn)
        
        var y = minHeight
        
        if indexPath.item >= columCount {
            y += lineSpacing
        }
        
        sumYHeights[minColumn] = y + height
        
        if contentHeight < sumYHeights.max()! {
            contentHeight = sumYHeights.max()!
        }
        
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = CGRect(x: x, y: y, width: width, height: height)
        return attributes

    }
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        guard self.columCount > 0 else {
            return nil
        }
        var resultAttrs = [UICollectionViewLayoutAttributes]()
        resultAttrs = self.itemAttributes.filter({ (attr) -> Bool in
            return attr.frame.intersects(rect)
        })
        //取出矩形 不相交的元素
        return resultAttrs
        
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else {
            return false
        }
        let oldBounds = collectionView.bounds
        
        return (oldBounds.width == newBounds.width) ? false : true
    }
    
    
    
}
