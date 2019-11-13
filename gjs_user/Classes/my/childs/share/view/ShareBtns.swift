//
//  ShareBtns.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/28.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

class ShareBtns: UIView {
    
    var btnShare = [UIButton]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .center
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(80)
            layout.paddingLeft = 15
            layout.paddingRight = 15
        }
        let btnArr = [
            [
                "name" : "分享链接",
                "img" : "share-2"
            ],
            [
                "name" : "分享海报",
                "img" : "share-3"
            ],
            [
                "name" : "地推二维码",
                "img" : "share-4"
            ],
            [
                "name" : "拉新红包设置",
                "img" : "share-5"
            ]
        ]
        for (index,item) in btnArr.enumerated() {
            let btnItem = UIButton()
            btnItem.tag = index + 1
            btnItem.configureLayout { (layout) in
                layout.isEnabled = true
                layout.flexDirection = .column
                layout.alignItems = .center
                layout.width = YGValue((kScreenW - 30) * 0.25)
            }
            self.addSubview(btnItem)
            let btnImg = UIImageView(image: UIImage(named: item["img"]!))
            btnImg.configureLayout { (layout) in
                layout.isEnabled = true
                layout.width = 36
                layout.height = 36
            }
            btnItem.addSubview(btnImg)
            let btnTitle = UILabel()
            btnTitle.text = item["name"]!
            btnTitle.textColor = kMainTextColor
            btnTitle.font = FontSize(12)
            btnTitle.configureLayout { (layout) in
                layout.isEnabled = true
                layout.marginTop = 10
            }
            btnItem.addSubview(btnTitle)
            btnShare.append(btnItem)
        }
        
        
        self.yoga.applyLayout(preservingOrigin: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
