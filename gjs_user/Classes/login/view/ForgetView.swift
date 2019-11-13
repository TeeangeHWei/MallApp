//
//  forgetView.swift
//  gjs_user
//
//  Created by xiaofeixia on 2019/8/23.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

class ForgetView: UIView {

    var phone:UITextField!
    var verify:UITextField!
    var verifyImg:UIImageView!
    var phoneCode:UITextField!
    var phoneCodeBtn:UIButton!
    var password:UITextField!
    var rePassword:UITextField!
    var btn:UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let mainView = UIView()
        mainView.frame = self.bounds
        let titleText = UILabel(frame: CGRect(x: 20, y: 10, width: kScreenW, height: 30))
        titleText.text = "找回密码"
        titleText.textColor = kMainTextColor
        titleText.textAlignment = .left
        titleText.font = FontSize(20)
        
        mainView.addSubview(titleText)
        
        phone = infoFiled(tip: "请输入手机号码", y: 60, width: kScreenW - 40, type: 0)
        mainView.addSubview(phone)
        //图片验证码
        verify = infoFiled(tip: "请输入图片验证码", y: 110, width: kScreenW - 115, type: 0)
        mainView.addSubview(verify)
        
        verifyImg = UIImageView()
        verifyImg.frame = CGRect(x: kScreenW - 85, y: 112, width: 65, height: 31)
        verifyImg.contentMode = .scaleAspectFit
        verifyImg.isUserInteractionEnabled = true
        mainView.addSubview(verifyImg)
        
        //短信验证码
        phoneCode = infoFiled(tip: "请输入短信验证码", y: 160, width: kScreenW - 135, type: 0)
        mainView.addSubview(phoneCode)
        
        phoneCodeBtn = UIButton(frame: CGRect(x: kScreenW - 100, y: 165, width: 80, height: 26))
        phoneCodeBtn.setTitle("获取验证码", for: .normal)
        phoneCodeBtn.setTitleColor(kLowOrangeColor, for: .normal)
        phoneCodeBtn.titleLabel?.font = FontSize(12)
        phoneCodeBtn.titleLabel?.textAlignment = .right
        phoneCodeBtn.layer.borderColor = kLowOrangeColor.cgColor
        phoneCodeBtn.layer.borderWidth = 1
        phoneCodeBtn.layer.cornerRadius = 13
        mainView.addSubview(phoneCodeBtn)
        
        password = infoFiled(tip: "请输入密码", y: 210, width: kScreenW - 40, type: 1)
        rePassword = infoFiled(tip: "请确认密码", y: 260, width: kScreenW - 40, type: 1)
        mainView.addSubview(password)
        mainView.addSubview(rePassword)
        
        btn = UIButton(frame: CGRect(x: 20, y: 340, width: kScreenW - 40, height: 40))
        btn.setTitle("找 回 密 码", for: .normal)
        btn.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), kCGGradientColors)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 6
        btn.titleLabel?.font = BoldFontSize(18)
        mainView.addSubview(btn)
        
        self.addSubview(mainView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //输入框部分
    func infoFiled(tip:String,y:CGFloat,width:CGFloat,type:Int = 0) -> UITextField{
        let filed = UITextField(frame: CGRect(x: 20, y: y, width: width, height: 35))
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
        return filed
    }
    
}
