//
//  flowController.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/2.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

class FlowController: UIViewController {

    var allHeight = 0
    
    override func viewDidLoad() {
        setNav(titleStr: "余额明细", titleColor: kMainTextColor, navItem: navigationItem, navController: navigationController)
        
        let body = UIScrollView()
        body.backgroundColor = .white
        body.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(kScreenH - headerHeight)
        }
        for _ in 1...3 {
            let flowItem = setFlowItem()
            body.addSubview(flowItem)
        }
        self.view.addSubview(body)
        
        
        body.contentInset = UIEdgeInsets(top: CGFloat(0), left: CGFloat(0), bottom: CGFloat(allHeight), right: CGFloat(0))
        body.yoga.applyLayout(preservingOrigin: true)
    }

    func setFlowItem () -> UIView {
        let flowItem = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 60))
        flowItem.addBorder(side: .bottom, thickness: 1, color: klineColor)
        flowItem.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.justifyContent = .spaceBetween
            layout.alignItems = .center
            layout.width = YGValue(kScreenW)
            layout.height = 60
            layout.paddingLeft = 15
            layout.paddingRight = 15
        }
        let itemLeft = UIView()
        itemLeft.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.justifyContent = .center
        }
        flowItem.addSubview(itemLeft)
        let title = UILabel()
        title.text = "充值"
        title.font = FontSize(14)
        title.configureLayout { (layout) in
            layout.isEnabled = true
            layout.marginBottom = 10
        }
        itemLeft.addSubview(title)
        let time = UILabel()
        time.text = "2019-05-16 16:44:30"
        time.font = FontSize(12)
        time.textColor = kGrayTextColor
        time.configureLayout { (layout) in
            layout.isEnabled = true
        }
        itemLeft.addSubview(time)
        let itemRight = UILabel()
        itemRight.text = "-15.0元"
        itemRight.font = FontSize(14)
        itemRight.textColor = kLowOrangeColor
        itemRight.configureLayout { (layout) in
            layout.isEnabled = true
        }
        flowItem.addSubview(itemRight)
        
        
        return flowItem
    }

}
