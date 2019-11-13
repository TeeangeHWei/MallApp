//
//  RouseFooterView.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/1.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

class RouseFooterView: UIView {

    var nav : UINavigationController?
    let leftLabel1 = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let footer = UIView()
        footer.addBorder(side: .top, thickness: 1, color: klineColor)
        footer.backgroundColor = .white
        footer.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .center
            layout.width = YGValue(kScreenW)
            layout.height = 60
        }
        self.addSubview(footer)
        let footerLeft = UIView()
        footerLeft.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.justifyContent = .center
            layout.width = YGValue(kScreenW * 0.7)
            layout.height = 60
            layout.paddingLeft = 15
        }
        footer.addSubview(footerLeft)
        leftLabel1.text = "0位会员，365天内未登录 "
        leftLabel1.font = FontSize(14)
        leftLabel1.configureLayout { (layout) in
            layout.isEnabled = true
            layout.marginBottom = 5
        }
        footerLeft.addSubview(leftLabel1)
        let leftLabel2 = UILabel()
        leftLabel2.text = "点击【短信唤醒】，让会员不再沉睡"
        leftLabel2.font = FontSize(12)
        leftLabel2.textColor = kGrayTextColor
        leftLabel2.configureLayout { (layout) in
            layout.isEnabled = true
        }
        footerLeft.addSubview(leftLabel2)
        
        let footerRight = UIButton(frame: CGRect(x: 0, y: 0, width: kScreenW * 0.3, height: 60))
        footerRight.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), kCGGradientColors)
        footerRight.setTitle("短信唤醒", for: .normal)
        footerRight.setTitleColor(.white, for: .normal)
        footerRight.titleLabel?.font = FontSize(14)
        footerRight.addTarget(self, action: #selector(toRouse), for: .touchUpInside)
        footerRight.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW * 0.3)
            layout.height = 60
        }
        footer.addSubview(footerRight)
        
        
        footer.yoga.applyLayout(preservingOrigin: true)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func toRouse () {
        nav?.pushViewController(ToRouseController(), animated: true)
    }
    
}
