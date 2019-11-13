//
//  SeckillView.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/28.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class SeckillView: UIScrollView {

    var allHeight = 0
    override init(frame: CGRect) {
        super.init(frame: frame)
        let body = self
        body.backgroundColor = kBGGrayColor
        body.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(kScreenH - headerHeight)
            layout.position = .relative
            layout.paddingTop = 70
        }
        
        allHeight += 70
        
        
        // 商品列表
        for _ in 1...10 {
            seckillList()
        }
        
        
        
        body.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(allHeight), right: CGFloat(0))
        body.yoga.applyLayout(preservingOrigin: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 商品列表
    func seckillList () {
        let goodsItem = GoodsItemView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 100))
        self.addSubview(goodsItem)
        allHeight += 130
    }
}
