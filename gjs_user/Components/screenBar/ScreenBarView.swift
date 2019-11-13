//
//  ScreenBarView.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/15.
//  Copyright © 2019 大杉网络. All rights reserved.
//

protocol sortDelegate {
    func sortDelegatefuc(backMsg:Int)
}

class ScreenBar: UIView {

    var sort = 0
    var screenLabelList = [UILabel]()
    var screenIconList = [UIImageView]()
    
    // 定义一个符合改协议的代理对象
    var delegate:sortDelegate?
    func processMethod(sort:Int?){
        if((delegate) != nil){
            delegate?.sortDelegatefuc(backMsg: sort!)
        }
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        
        // 筛选栏
        let screenBar = self
        screenBar.backgroundColor = .white
        screenBar.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.justifyContent = .spaceAround
            layout.alignItems = .center
            layout.width = YGValue(kScreenW)
            layout.height = 40
        }
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
        
        for (index, item) in screenList.enumerated() {
            let screenItem = UIButton()
            screenItem.tag = index
            screenItem.addTarget(self, action: #selector(sortChange), for: .touchUpInside)
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
            if index == 0 {
                itemLabel.textColor = kLowOrangeColor
            } else {
                itemLabel.textColor = colorwithRGBA(150,150,150,1)
            }
            itemLabel.configureLayout { (layout) in
                layout.isEnabled = true
            }
            screenItem.addSubview(itemLabel)
            screenLabelList.append(itemLabel)
            if item["icon"] != nil {
                let itemIcon = UIImageView(image: UIImage(named: "screen-1"))
                itemIcon.configureLayout { (layout) in
                    layout.isEnabled = true
                    layout.width = 8
                    layout.height = 14
                    layout.marginLeft = 3
                }
                screenItem.addSubview(itemIcon)
                screenIconList.append(itemIcon)
            }
        }
        // 列表格式
        //        let listType = UIImageView(image: UIImage(named: "listType-1"))
//        listType.isUserInteractionEnabled = true
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.listTypeChange(sender:)))
//        listType.addGestureRecognizer(tap)
//        listType.configureLayout { (layout) in
//            layout.isEnabled = true
//            layout.width = 18
//            layout.height = 18
//        }
//        screenBar.addSubview(listType)
        
        
        screenBar.yoga.applyLayout(preservingOrigin: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func sortChange (_ btn : UIButton) {
        var index = btn.tag
        for (labelIndex, item) in screenLabelList.enumerated() {
            if labelIndex == index {
                item.textColor = kLowOrangeColor
            } else {
                item.textColor = colorwithRGBA(150,150,150,1)
            }
        }
        for item in screenIconList {
            item.image = UIImage(named: "screen-1")
        }
        if index == 0 {
            sort = 0
        } else if index == 1 {
            if sort == 1 {
                sort = 2
                screenIconList[0].image = UIImage(named: "screen-3")
            } else {
                sort = 1
                screenIconList[0].image = UIImage(named: "screen-2")
            }
        } else if index == 2 {
            if sort == 7 {
                sort = 4
                screenIconList[1].image = UIImage(named: "screen-3")
            } else {
                sort = 7
                screenIconList[1].image = UIImage(named: "screen-2")
            }
        } else if index == 3 {
            if sort == 8 {
                sort = 5
                screenIconList[2].image = UIImage(named: "screen-3")
            } else {
                sort = 8
                screenIconList[2].image = UIImage(named: "screen-2")
            }
        }
        // 触发回调函数
        processMethod(sort:sort)
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
