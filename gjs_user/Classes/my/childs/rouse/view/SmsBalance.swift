//
//  smsBalance.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/2.
//  Copyright © 2019 大杉网络. All rights reserved.
//

class SmsBalance: UIView {

    let smsBalance = UILabel()
    let smsCost = UILabel()
    let rechargeBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 22))
    let withdrawBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 22))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let body = UIView()
        body.backgroundColor = .white
        body.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.justifyContent = .spaceBetween
            layout.alignItems = .center
            layout.width = YGValue(kScreenW)
            layout.height = 60
            layout.paddingLeft = 15
            layout.paddingRight = 15
        }
        // 左
        let left = UIView()
        left.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .column
            layout.justifyContent = .center
            layout.height = 60
        }
        body.addSubview(left)
        smsBalance.text = "短信余额：25.00"
        smsBalance.font = FontSize(14)
        smsBalance.configureLayout { (layout) in
            layout.isEnabled = true
            layout.marginBottom = 5
        }
        left.addSubview(smsBalance)
        smsCost.text = "短信收费标准：0.04元/条"
        smsCost.font = FontSize(12)
        smsCost.textColor = kGrayTextColor
        smsCost.configureLayout { (layout) in
            layout.isEnabled = true
        }
        left.addSubview(smsCost)
        // 右
        let right = UIView()
        right.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .center
        }
        body.addSubview(right)
        rechargeBtn.addTarget(self, action: #selector(toRecharge), for: .touchUpInside)
        rechargeBtn.backgroundColor = colorwithRGBA(255, 233, 219, 1)
        rechargeBtn.setTitle("充值", for: .normal)
        rechargeBtn.setTitleColor(kLowOrangeColor, for: .normal)
        rechargeBtn.titleLabel?.font = FontSize(14)
        rechargeBtn.layer.cornerRadius = 10
        rechargeBtn.layer.masksToBounds = true
        rechargeBtn.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 60
            layout.height = 22
        }
        right.addSubview(rechargeBtn)
        withdrawBtn.addTarget(self, action: #selector(toWithdraw), for: .touchUpInside)
        withdrawBtn.backgroundColor = colorwithRGBA(255, 233, 219, 1)
        withdrawBtn.setTitle("提现", for: .normal)
        withdrawBtn.setTitleColor(kLowOrangeColor, for: .normal)
        withdrawBtn.titleLabel?.font = FontSize(14)
        withdrawBtn.layer.cornerRadius = 10
        withdrawBtn.layer.masksToBounds = true
        withdrawBtn.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = 60
            layout.height = 22
            layout.marginLeft = 10
        }
        right.addSubview(withdrawBtn)
        
        
        body.yoga.applyLayout(preservingOrigin: true)
        self.addSubview(body)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // 充值按钮点击事件
    @objc func toRecharge (_ btn: UIButton) {
        let rechargePop = RechargePop(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH))
        self.window?.addSubview(rechargePop)
    }
    // 提现按钮点击事件
    @objc func toWithdraw (_ btn: UIButton) {
        let withdrawPop = WithdrawPop(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH))
        self.window?.addSubview(withdrawPop)
    }
    
}
