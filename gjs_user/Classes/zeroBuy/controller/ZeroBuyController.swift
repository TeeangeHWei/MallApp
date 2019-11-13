//
//  ZeroBuyController.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/18.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

class ZeroBuyController: ViewController {
    
    var allHeight = 0
    let number = UILabel()
    
    override func viewDidLoad() {
        setNav(titleStr: "粉丝0元购", titleColor: kMainTextColor, navItem: navigationItem, navController: navigationController)
        view.backgroundColor = .white
        let body = UIScrollView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH - 40))
        body.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(kScreenH - 40)
        }
        // banner
        let bannerView = UIView()
        bannerView.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(kScreenW * 0.84)
            layout.position = .relative
        }
        body.addSubview(bannerView)
        let bannerImg = UIImageView(image: UIImage(named: "zeroBuy-banner"))
        bannerImg.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(kScreenW * 0.84)
        }
        bannerView.addSubview(bannerImg)
        let ruleBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 24))
        ruleBtn.layer.mask = ruleBtn.configRectCorner(view: ruleBtn, corner: [.bottomLeft, .topLeft], radii: CGSize(width: 10, height: 10))
        ruleBtn.setTitle("活动规则", for: .normal)
        ruleBtn.setTitleColor(kLowOrangeColor, for: .normal)
        ruleBtn.backgroundColor = .white
        ruleBtn.titleLabel?.font = FontSize(14)
        ruleBtn.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 80
            layout.height = 24
            layout.position = .absolute
            layout.right = 0
            layout.top = 15
        }
        bannerView.addSubview(ruleBtn)
        // 步骤
        let stepView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 80))
        stepView.backgroundColor = .white
        stepView.layer.mask = stepView.configRectCorner(view: stepView, corner: [.topRight, .topLeft], radii: CGSize(width: 10, height: 10))
        stepView.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.justifyContent = .spaceAround
            layout.marginTop = -20
            layout.width = YGValue(kScreenW)
            layout.padding = 15
            layout.paddingLeft = 20
            layout.paddingRight = 20
        }
        body.addSubview(stepView)
        for index in 1...3 {
            let stepItem = UIView()
            stepItem.configureLayout { (layout) in
                layout.isEnabled = true
                layout.alignItems = .center
//                layout.width = YGValue(kScreenW)
            }
            stepView.addSubview(stepItem)
            let itemImg = UIImageView(image: UIImage(named: "zeroBuy-\(index)"))
            itemImg.configureLayout { (layout) in
                layout.isEnabled = true
                layout.width = 35
                layout.height = 35
                layout.marginBottom = 10
            }
            stepItem.addSubview(itemImg)
            var itemText = "1.点击商品"
            if index == 2 {
                itemText = "2.补贴购买"
            } else if index == 3 {
                itemText = "3.收货返现"
            }
            let itemLabel = UILabel()
            itemLabel.text = itemText
            itemLabel.font = FontSize(14)
            itemLabel.textColor = kMainTextColor
            itemLabel.configureLayout { (layout) in
                layout.isEnabled = true
            }
            stepItem.addSubview(itemLabel)
        }
        // 当前次数
        let currentNumber = UIView()
        currentNumber.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.justifyContent = .center
        }
        body.addSubview(currentNumber)
        let numberLeft = UILabel()
        numberLeft.text = "当前拥有"
        numberLeft.textColor = kMainTextColor
        numberLeft.font = FontSize(14)
        numberLeft.configureLayout { (layout) in
            layout.isEnabled = true
        }
        currentNumber.addSubview(numberLeft)
        number.text = "0"
        number.textColor = kLowOrangeColor
        number.font = FontSize(18)
        number.textAlignment = .center
        number.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 30
        }
        currentNumber.addSubview(number)
        let numberRight = UILabel()
        numberRight.text = "次参与0元购资格"
        numberRight.textColor = kMainTextColor
        numberRight.font = FontSize(14)
        numberRight.configureLayout { (layout) in
            layout.isEnabled = true
        }
        currentNumber.addSubview(numberRight)
        // 新老用户
        let newOld = UIView()
        newOld.layer.borderWidth = 1
        newOld.layer.borderColor = kLowOrangeColor.cgColor
        newOld.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW - 20)
            layout.marginLeft = 10
            layout.marginTop = 15
            layout.padding = 10
        }
        body.addSubview(newOld)
        let newLabel = UILabel()
        newLabel.text = "新用户：注册即可享受一次0元购"
        newLabel.font = FontSize(14)
        newLabel.textColor = kLowOrangeColor
        newLabel.numberOfLines = 0
        newLabel.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW - 40)
            layout.marginBottom = 10
        }
        newOld.addSubview(newLabel)
        let oldLabel = UILabel()
        oldLabel.text = "老用户：邀请三个有效会员（完成淘宝授权），可再次获取一次0元购"
        oldLabel.font = FontSize(14)
        oldLabel.textColor = kLowOrangeColor
        oldLabel.numberOfLines = 0
        oldLabel.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW - 40)
            layout.marginBottom = 10
        }
        newOld.addSubview(oldLabel)
        let totalLabel = UILabel()
        totalLabel.text = "已结算订单于次月25号前到账提现。"
        totalLabel.font = FontSize(14)
        totalLabel.textColor = kLowOrangeColor
        totalLabel.numberOfLines = 0
        totalLabel.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW - 40)
        }
        newOld.addSubview(totalLabel)
        
        
        
        body.yoga.applyLayout(preservingOrigin: true)
        body.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(allHeight + 40), right: CGFloat(0))
//        body.delegate = self
        view.addSubview(body)
    }

}
