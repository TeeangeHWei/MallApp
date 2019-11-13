//
//  screenBar.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/13.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

class ScreenBarView: UIViewController {
    
    lazy var screenBar = { () -> UIView in
        let containerSize = self.view.bounds.size
        
        // 筛选栏
        let screenBar = UIView()
        screenBar.backgroundColor = .white
        screenBar.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.justifyContent = .spaceAround
            layout.alignItems = .center
            layout.width = YGValue(containerSize.width)
            layout.height = 40
        }
        self.view.addSubview(screenBar)
        let screenList = [
            [
                "name": "综合"
            ],
            [
                "name": "券后价",
                "icon": 1
            ],
            [
                "name": "销量",
                "icon": 1
            ],
            [
                "name": "佣金比例",
                "icon": 1
            ]
        ]
        
        for item in screenList {
            let screenItem = UIView()
            screenItem.configureLayout { (layout) in
                layout.isEnabled = true
                layout.flexDirection = .row
                layout.justifyContent = .center
                layout.alignItems = .center
                layout.height = 40
            }
            screenBar.addSubview(screenItem)
            let itemLabel = UILabel()
            itemLabel.text = item["name"] as! String
            itemLabel.font = FontSize(12)
            itemLabel.textColor = colorwithRGBA(150,150,150,1)
            itemLabel.configureLayout { (layout) in
                layout.isEnabled = true
            }
            screenItem.addSubview(itemLabel)
            if item["icon"] != nil {
                let itemIcon = UIImageView(image: UIImage(named: "screen-1"))
                itemIcon.configureLayout { (layout) in
                    layout.isEnabled = true
                    layout.width = 8
                    layout.height = 14
                    layout.marginLeft = 3
                }
                screenItem.addSubview(itemIcon)
            }
        }
        // 列表格式
        //        let listType = UIImageView(image: UIImage(named: "listType-1"))
        listType.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.listTypeChange(sender:)))
        listType.addGestureRecognizer(tap)
        listType.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 18
            layout.height = 18
        }
        screenBar.addSubview(listType)
        
        
        screenBar.yoga.applyLayout(preservingOrigin: true)
        
        return screenBar
    }
    
    override func viewDidLoad() {
        
        
    }
    

    @objc func listTypeChange (sender:UITapGestureRecognizer) {
        if listTypeNum == 1 {
            listTypeNum = 2
            listType = UIImageView(image: UIImage(named: "listType-2"))
        } else {
            listTypeNum = 1
            listType = UIImageView(image: UIImage(named: "listType-1"))
        }
    }

}
