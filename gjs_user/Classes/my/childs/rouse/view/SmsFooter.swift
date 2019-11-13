//
//  SmsFooter.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/2.
//  Copyright © 2019 大杉网络. All rights reserved.
//

class SmsFooter: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, nav: UINavigationController?) {
        self.init(frame: frame)
        
        
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 60))
        footer.backgroundColor = .white
        footer.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.width = YGValue(kScreenW)
            layout.height = 60
        }
        self.addSubview(footer)
        let footerLeft = UIView()
        footerLeft.addBorder(side: .top, thickness: 1, color: klineColor)
        footerLeft.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.justifyContent = .center
            layout.width = YGValue(kScreenW * 0.7)
            layout.height = 60
            layout.paddingLeft = 20
        }
        footer.addSubview(footerLeft)
        // 左
        let leftLabel1  = UILabel()
        leftLabel1.text = "可发送用户\(memberNum)人，短信费用\(Double(memberNum) * Commons.strToDou((smsData?.smsCost!)!))元"
        leftLabel1.font = FontSize(14)
        leftLabel1.configureLayout { (layout) in
            layout.isEnabled = true
            layout.marginBottom = 5
        }
        footerLeft.addSubview(leftLabel1)
        let leftLabel2  = UILabel()
        leftLabel2.text = "已过滤未设置手机号码的用户"
        leftLabel2.font = FontSize(12)
        leftLabel2.textColor = kGrayTextColor
        leftLabel2.configureLayout { (layout) in
            layout.isEnabled = true
        }
        footerLeft.addSubview(leftLabel2)
        
        // 右
        let footerRight = UIButton(frame: CGRect(x: 0, y: 0, width: kScreenW * 0.3, height: 60))
        footerRight.setTitle("发送短信", for: .normal)
        footerRight.titleLabel?.font = FontSize(16)
        footerRight.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), kCGGradientColors)
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
    

}
