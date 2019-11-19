//
//  signupView.swift
//  gjs_user
//
//  Created by xiaofeixia on 2019/8/23.
//  Copyright © 2019 大杉网络. All rights reserved.
//
import UIKit

class SignupView: UIView {
    
    var bodyView:UIView!
    var titleText:UILabel!
    var nextBtn:UIButton!
    var invite:UITextField!
    var inviteInfo:UIView!
    var phone:UITextField!
    var verify:UITextField!
    var verifyImg:UIImageView!
    var phoneCode:PhoneCodeView!
    var phoneCodeBtn:UIButton!
    var password:UITextField!
    var rePassword:UITextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let mainView = UIView()
        mainView.frame = self.bounds
        titleText = UILabel(frame: CGRect(x: 20, y: 10, width: kScreenW, height: 30))
        titleText.textColor = kMainTextColor
        titleText.textAlignment = .left
        titleText.font = FontSize(20)
        mainView.addSubview(titleText)
        
        //下一步按钮
        nextBtn = UIButton()
        nextBtn.layer.masksToBounds = true
        nextBtn.layer.cornerRadius = 6
        nextBtn.titleLabel?.font = FontSize(18)
        activeBtn(flag: false)
        
        //动态变化的内容
        bodyView = UIView()
        mainView.addSubview(bodyView)
        
        mainView.addSubview(nextBtn)
        self.addSubview(mainView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //填写上级（第一步）========================
    func firstStep(){
        bodyView.subviews.forEach{$0.removeFromSuperview()}
        //邀请码或手机输入框
        invite = textFiled(tip: "请输入邀请码或邀请人手机号", y: 0)
        inviteInfo = UIView(frame: CGRect(x: 20, y: 55, width: kScreenW - 40, height: 80))
        
        self.setStep(y: 145)
        bodyView.frame = CGRect(x: 0, y: 60, width: kScreenW, height: 85)
        bodyView.addSubview(invite)
        bodyView.addSubview(inviteInfo)
    }
    
    //（渲染/清除）上级信息
    func superInfo(headerStr:String="",nickStr:String=""){
        inviteInfo.subviews.forEach{$0.removeFromSuperview()}
        if(headerStr==""&&nickStr==""){
            inviteInfo.layer.borderWidth = 0
            setStep(y: 145)
            bodyView.frame = CGRect(x: 0, y: 60, width: kScreenW, height: 85)
            return
        }
        inviteInfo.layer.borderWidth = 1
        inviteInfo.layer.borderColor = kLowOrangeColor.cgColor
        inviteInfo.layer.cornerRadius = 5
        let url = URL(string: UrlFilter(headerStr))!
        let placeholderImage = UIImage(named: "loading")
        let header = UIImageView(frame: CGRect(x: 20, y: 10, width: 60, height: 60))
        header.af_setImage(withURL: url, placeholderImage: placeholderImage)
        header.layer.masksToBounds = true
        header.layer.cornerRadius = 30
        
        let nick = UILabel(frame: CGRect(x: 95, y: 15, width: 180, height: 20))
        nick.text = nickStr
        nick.textColor = kMainTextColor
        nick.font = FontSize(14)
        
        let tip = UILabel(frame: CGRect(x: 95, y: 45, width: 120, height: 20))
        tip.text = "欢迎进入赶紧省"
        tip.textColor = kGrayTextColor
        tip.font = FontSize(14)
        
        inviteInfo.addSubview(header)
        inviteInfo.addSubview(nick)
        inviteInfo.addSubview(tip)
        setStep(y: 225)
        bodyView.frame = CGRect(x: 0, y: 60, width: kScreenW, height: 165)
    }
    
    //第一步结束======================
    
    //填写手机号（第二步）===============
    func secondStep(){
        bodyView.subviews.forEach{$0.removeFromSuperview()}
        //手机提示
        let tip = UILabel(frame: CGRect(x: 20, y: 0, width: kScreenW - 40, height: 35))
        tip.text = "中国（+86）"
        tip.font = FontSize(16)
        tip.textColor = kMainTextColor
        //底部边框
        let tipLayer = CALayer()
        tipLayer.frame = CGRect(x: 0, y: 35, width: kScreenW-40, height: 1)
        tipLayer.backgroundColor = klineColor.cgColor
        tip.layer.addSublayer(tipLayer)
        
        //手机输入框
        phone = textFiled(tip: "请输入手机号码", y: 55)

        //按钮上边距40
        self.setStep(title : "请输入手机号码", y: 200)
        bodyView.frame = CGRect(x: 0, y: 60, width: kScreenW, height: 140)
        bodyView.addSubview(tip)
        bodyView.addSubview(phone)
    }
    
    //第二步结束=========================
    
    //输入验证码（第三步）=================
    func thridStep(){
        bodyView.subviews.forEach{$0.removeFromSuperview()}
        //图片输入框
        verify = UITextField(frame: CGRect(x: 20, y: 0, width: kScreenW - 120, height: 35))
        verify.placeholder = "请输入图片验证码"
        verify.keyboardType = .numberPad
        verify.font = FontSize(16)
        verify.clearButtonMode = .whileEditing
        //底部边框
        let verifyLayer = CALayer()
        verifyLayer.frame = CGRect(x: 0, y: 35, width: kScreenW-40, height: 1)
        verifyLayer.backgroundColor = klineColor.cgColor
        verify.layer.addSublayer(verifyLayer)
        
        verifyImg = UIImageView()
        verifyImg.frame = CGRect(x: kScreenW - 85, y: 0, width: 65, height: 31)
        verifyImg.contentMode = .scaleAspectFit
        verifyImg.isUserInteractionEnabled = true
        bodyView.addSubview(verify)
        bodyView.addSubview(verifyImg)
        
        //短信验证码
        phoneCode = PhoneCodeView(x: 20, y: 75, width: (kScreenW-40)/6-5, height: 35, pore: 5, num: 6)
        phoneCode.font = FontSize(16)
        phoneCode.textColor = kMainTextColor
        
        phoneCodeBtn = UIButton(frame: CGRect(x: 20, y: 125, width: 80, height: 26))
        phoneCodeBtn.setTitle("获取验证码", for: .normal)
        phoneCodeBtn.setTitleColor(kLowOrangeColor, for: .normal)
        phoneCodeBtn.layer.borderWidth = 1
        phoneCodeBtn.layer.borderColor = kLowOrangeColor.cgColor
        phoneCodeBtn.layer.masksToBounds = true
        phoneCodeBtn.layer.cornerRadius = 13
        phoneCodeBtn.titleLabel?.font = FontSize(12)
        
        //按钮上边距40
        self.setStep(title : "请输入验证码", y: 145)
        bodyView.frame = CGRect(x: 0, y: 60, width: kScreenW, height: 85)
    }
    
    //是否显示验证码输入框
    func phoneCodeShow(){
        //验证码输入框
        let phoneTip = UILabel(frame: CGRect(x: 20, y: 55, width: kScreenW - 40, height: 20))
        phoneTip.text = "验证码已发送至手机 +86 " + phone.text!
        phoneTip.font = FontSize(14)
        phoneTip.textColor = kMainTextColor
        bodyView.addSubview(phoneTip)
        bodyView.addSubview(phoneCode)
        bodyView.addSubview(phoneCodeBtn)
        
        //按钮上边距40
        self.setStep(title : "请输入验证码", y: 220)
        bodyView.frame = CGRect(x: 0, y: 60, width: kScreenW, height: 160)
    }
    
    //第三步结束====================
    
    //输入密码（第四步）==============
    func fourthStep(){
        bodyView.subviews.forEach{$0.removeFromSuperview()}
        password = textFiled(tip: "请输入密码", y: 0,type: 1)
        rePassword = textFiled(tip: "请确认密码", y: 55,type: 1)
        self.setStep(title : "请输入密码", y: 200, btnStr: "注 册")
        bodyView.frame = CGRect(x: 0, y: 60, width: kScreenW, height: 140)
        bodyView.addSubview(password)
        bodyView.addSubview(rePassword)
    }
    
    //第四部结束====================
    
    
    //公共方法======================
    //文本输入框标准方法
    private func textFiled(tip:String,y:CGFloat,type:Int = 0) -> UITextField{
        let filed = UITextField(frame: CGRect(x: 20, y: y, width: kScreenW - 40, height: 35))
        filed.placeholder = tip
        filed.font = FontSize(16)
        filed.clearButtonMode = .whileEditing
        //底部边框
        let filedLayer = CALayer()
        filedLayer.frame = CGRect(x: 0, y: 35, width: kScreenW-40, height: 1)
        filedLayer.backgroundColor = klineColor.cgColor
        filed.layer.addSublayer(filedLayer)
        if(type == 1){ //密码输入
            filed.isSecureTextEntry = true
        }
        return filed
    }
    
    
    /// 设置顶部文字和底部按钮
    ///
    /// - Parameters:
    ///   - title: 顶部文字
    ///   - y: 底部按钮上边距
    ///   - btnStr: 底部按钮文字
    func setStep(title:String = "请输入邀请人信息", y:CGFloat, btnStr:String = "下 一 步"){
        self.titleText.text = title
        self.nextBtn.frame = CGRect(x: 20, y: y, width: kScreenW - 40, height: 40)
        self.nextBtn.setTitle(btnStr, for: .normal)
        self.nextBtn.backgroundColor = kGrayBtnColor
        self.nextBtn.setTitleColor(kMainTextColor, for: .normal)
    }
    
    /// 按钮选中可选事件
    ///
    /// - Parameter flag: true:可选，false:禁止
    func activeBtn(flag:Bool){
        if(flag){
            nextBtn.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), kCGGradientColors)
            nextBtn.setTitleColor(.white, for: .normal)
            nextBtn.isUserInteractionEnabled = true
        }else{
            nextBtn.removeGradientLayer()
            nextBtn.backgroundColor = kGrayBtnColor
            nextBtn.setTitleColor(kMainTextColor, for: .normal)
            nextBtn.isUserInteractionEnabled = false
        }
    }
    
}
