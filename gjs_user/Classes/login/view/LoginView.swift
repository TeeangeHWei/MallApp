//
//  LoginView.swift
//  gjs_user
//
//  Created by xiaofeixia on 2019/8/23.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

class LoginView: UIView {
    var navigation:UINavigationController?
    var sms:UILabel!
    var forget:UILabel!
    var btn:UIButton!
    var account:UITextField!
    var password:UITextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        let mainView = UIView()
        mainView.frame = self.bounds
        let titleText = UILabel(frame: CGRect(x: 20, y: 10, width: kScreenW, height: 30))
        titleText.text = "欢迎登录"
        titleText.textColor = kMainTextColor
        titleText.textAlignment = .left
        titleText.font = FontSize(20)
        
        mainView.addSubview(titleText)
        
        account = infoFiled(parent: mainView, tip: "请输入手机号码", y: 60, type: 0)
        account.keyboardType = .numberPad
        password = infoFiled(parent: mainView, tip: "请输入密码", y: 110, type: 1)
        
        btn = UIButton(frame: CGRect(x: 20, y: 180, width: kScreenW - 40, height: 40))
        btn.setTitle("登 录", for: .normal)
        btn.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), kCGGradientColors)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 6
        btn.titleLabel?.font = BoldFontSize(18)
        mainView.addSubview(btn)
        
        sms = UILabel(frame: CGRect(x: 20, y: 230, width: (kScreenW - 40)/2, height: 30))
        sms.text = "短信验证码登录"
        sms.textColor = kLowOrangeColor
        sms.textAlignment = .left
        sms.font = FontSize(14)
        sms.isUserInteractionEnabled = true
        forget = UILabel(frame: CGRect(x: (kScreenW - 40)/2+20, y: 230, width: (kScreenW - 40)/2, height: 30))
        forget.text = "忘记密码？"
        forget.textColor = kLowOrangeColor
        forget.textAlignment = .right
        forget.font = FontSize(14)
        forget.isUserInteractionEnabled = true
        mainView.addSubview(sms)
        mainView.addSubview(forget)
        
        let tip = UILabel(frame: CGRect(x: 20, y: 280, width: kScreenW - 40, height: 20))
        tip.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(privacy))
        tip.addGestureRecognizer(tap)
        let tip1 = "登录即代表您已同意"
        let tip2 = "《赶紧省隐私协议》"
        let tipTotal = NSMutableAttributedString(string: tip1 + tip2)
        let tipTemp1 : NSRange = (tipTotal.string as NSString).range(of:tip1)
        let tipTemp2 : NSRange = (tipTotal.string as NSString).range(of:tip2)
        tipTotal.addAttribute(NSAttributedString.Key.foregroundColor, value: kMainTextColor, range: tipTemp1)
        tipTotal.addAttribute(NSAttributedString.Key.foregroundColor, value: kLowOrangeColor, range: tipTemp2)
        tip.attributedText = tipTotal
        tip.font = FontSize(12)
        tip.textAlignment = .center
        mainView.addSubview(tip)
        self.addSubview(mainView)
    }
    @objc func privacy(){
        print("点击了。。。。。。")
        navigation?.pushViewController(privacyViewController(), animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //输入框部分
    func infoFiled(parent:UIView,tip:String,y:CGFloat,type:Int) -> UITextField {
        let filed = UITextField(frame: CGRect(x: 20, y: y, width: kScreenW - 40, height: 35))
        filed.placeholder = tip
        filed.font = FontSize(16)
        filed.clearButtonMode = .whileEditing
        //底部边框
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 35, width: kScreenW-40, height: 1)
        layer.backgroundColor = klineColor.cgColor
        filed.layer.addSublayer(layer)
        if type == 1{
            filed.isSecureTextEntry = true
        }
        parent.addSubview(filed)
        return filed
    }
    
}
