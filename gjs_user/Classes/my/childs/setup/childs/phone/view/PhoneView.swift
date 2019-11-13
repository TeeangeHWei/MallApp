//
//  phoneView.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/19.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

class PhoneView: ViewController {
    
    private var step = 1
    
    private let formList = UIView()
    private let formList1 = UIView()
    private let submitBtn = UIButton(frame: CGRect(x: 0, y: 0, width: kScreenW * 0.8, height: 40))
    
    
    private let codeInput = IDTextField()
    private let imgCodeInput = IDTextField()
    private let codeImg:UIImageView = UIImageView()
    private var imgSign:String! = ""
    private let codeBtn = UIButton()
    private var codeSign:String! = ""
    
    private let phoneInput = IDTextField()
    private let imgCodeInput1 = IDTextField()
    private let codeImg1:UIImageView = UIImageView()
    private var imgSign1:String! = ""
    private let codeBtn1 = UIButton()
    private let codeInput1 = IDTextField()
    private var codeSign1:String! = ""
    
    override func viewDidLoad() {
        let navView = customNav(titleStr: "修改手机号", titleColor: kMainTextColor)
        self.view.addSubview(navView)
        let body = UIScrollView(frame: CGRect(x: 0, y: headerHeight, width: kScreenW, height: kScreenH - headerHeight))
        body.backgroundColor = kBGGrayColor
        body.addBorder(side: .top, thickness: 1, color: klineColor)
        body.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(kScreenH - headerHeight)
            layout.paddingTop = 1
            layout.position = .relative
        }
        self.view.addSubview(body)
        
        // 表单列表 ---- 第一步
        formList.backgroundColor = .white
        formList.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.marginTop = 10
            layout.position = .absolute
        }
        body.addSubview(formList)
        // 原手机号
        let phoneNum : String = UserDefaults.getInfo()["phone"] as! String
        let hiddenNum :String = phoneNum.id_subString(from: 0, offSet: 3)+"****"+phoneNum.id_subString(from: 7, offSet: 11)
        
        let oldPhone = formItem(isInput: false, leftS: "原手机号", centerV: imgCodeInput, centerS: hiddenNum, isValue: true, maxlength: 4)
        formList.addSubview(oldPhone)
        // 图片验证码
        let imgCode = formItem(isInput: true, leftS: "图片验证码", centerV: imgCodeInput, centerS: "请输入图片验证码", isValue: false, maxlength: 4)
        formList.addSubview(imgCode)
        
        imgCodeClick()
        codeImg.isUserInteractionEnabled = true
        codeImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imgCodeClick)))
        codeImg.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(69)
            layout.height = YGValue(30)
        }
        imgCode.addSubview(codeImg)
        // 验证码
        let code = formItem(isInput: true, leftS: "验证码", centerV: codeInput, centerS: "请输入验证码", isValue: false, maxlength: 6)
        formList.addSubview(code)
        
        CountDown.countDownSchedule(btn: codeBtn1)
        codeBtn.addTarget(self, action: #selector(phoneCodeClick), for: .touchUpInside)
        codeBtn.setTitle("获取验证码", for: .normal)
        codeBtn.setTitleColor(kLowOrangeColor, for: .normal)
        codeBtn.titleLabel?.font = FontSize(12)
        codeBtn.backgroundColor = .clear
        codeBtn.layer.borderColor = kLowOrangeColor.cgColor
        codeBtn.layer.borderWidth = 1
        codeBtn.layer.cornerRadius = 13
        codeBtn.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(80)
            layout.height = YGValue(26)
        }
        code.addSubview(codeBtn)
        
        
        // 表单列表 ---- 第二步
        formList1.isHidden = true
        formList1.backgroundColor = .white
        formList1.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.marginTop = 10
            layout.position = .absolute
        }
        body.addSubview(formList1)
        // 新手机号
        let newPhone = formItem(isInput: true, leftS: "新手机号", centerV: phoneInput, centerS: "请输入您的新手机号", isValue: false, maxlength: 11)
        formList1.addSubview(newPhone)
        // 图片验证码
        let imgCode1 = formItem(isInput: true, leftS: "图片验证码", centerV: imgCodeInput1, centerS: "请输入图片验证码", isValue: false, maxlength: 4)
        formList1.addSubview(imgCode1)
        
        imgCodeClick1()
        codeImg1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imgCodeClick1)))
        codeImg1.isUserInteractionEnabled = true
        codeImg1.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(69)
            layout.height = YGValue(30)
        }
        imgCode1.addSubview(codeImg1)
        // 验证码
        let code1 = formItem(isInput: true, leftS: "验证码", centerV: codeInput1, centerS: "请输入验证码", isValue: false, maxlength: 6)
        formList1.addSubview(code1)
        
        codeBtn1.addTarget(self, action: #selector(phoneCodeClick1), for: .touchUpInside)
        codeBtn1.setTitle("获取验证码", for: .normal)
        codeBtn1.setTitleColor(kLowOrangeColor, for: .normal)
        codeBtn1.titleLabel?.font = FontSize(12)
        codeBtn1.backgroundColor = .clear
        codeBtn1.layer.borderColor = kLowOrangeColor.cgColor
        codeBtn1.layer.borderWidth = 1
        codeBtn1.layer.cornerRadius = 13
        codeBtn1.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(80)
            layout.height = YGValue(26)
        }
        code1.addSubview(codeBtn1)
        
        
        // -------- 提交按钮 --------
        submitBtn.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), kCGGradientColors)
        submitBtn.tag = 1
        submitBtn.setTitle("下一步", for: .normal)
        submitBtn.addTarget(self, action: #selector(submit), for: .touchUpInside)
        submitBtn.setTitleColor(.white, for: .normal)
        submitBtn.titleLabel?.font = FontSize(14)
        submitBtn.layer.cornerRadius = 3
        submitBtn.layer.masksToBounds = true
        submitBtn.layer.shadowColor = kLowOrangeColor.cgColor
        submitBtn.layer.shadowOpacity = 0.5
        submitBtn.layer.shadowRadius = 3
        submitBtn.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW * 0.8)
            layout.height = 40
            layout.marginTop = 180
            layout.marginLeft = YGValue(kScreenW * 0.1)
        }
        body.addSubview(submitBtn)
        
        body.yoga.applyLayout(preservingOrigin: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideKeyboardWhenTappedAround()
    }
    
    // 表单单项
    func formItem (isInput: Bool, leftS: String, centerV: IDTextField, centerS: String, isValue: Bool, maxlength: Int) -> UIView {
        let formItem = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 50))
        formItem.addBorder(side: .bottom, thickness: 1, color: klineColor)
        formItem.configureLayout { (layout) in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.alignItems = .center
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(50)
            layout.paddingLeft = 15
            layout.paddingRight = 15
        }
        let itemWidth = kScreenW - 30
        let key = UILabel()
        key.font = FontSize(14)
        key.text = leftS
        key.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(itemWidth * 0.25)
        }
        formItem.addSubview(key)
        if isInput {
            centerV.clearButtonMode = .whileEditing
            centerV.font = FontSize(14)
            centerV.maxLength = maxlength
            centerV.onlyNumber = true
            centerV.keyboardType = UIKeyboardType.numberPad
            if isValue {
                centerV.text = centerS
            } else {
                centerV.placeholder = centerS
            }
            centerV.configureLayout { (layout) in
                layout.isEnabled = true
                layout.width = YGValue(itemWidth * 0.5)
            }
            formItem.addSubview(centerV)
        } else {
            let center = UILabel()
            center.text = centerS
            center.font = FontSize(14)
            center.textColor = kLowGrayColor
            center.configureLayout { (layout) in
                layout.isEnabled = true
                layout.width = YGValue(itemWidth * 0.5)
            }
            formItem.addSubview(center)
        }
        return formItem
    }
    //旧图片验证码
    @objc func imgCodeClick(){
        AlamofireUtil.get(url: "/public/verifyCode",
        success: {(res,data) in
            self.codeImg.image = UIImage(data: data)
            self.imgSign = res.allHeaderFields[AnyHashable("verifysign")] as? String
        },
        failure: {
        })
    }
    
    //旧手机获取验证码
    @objc func phoneCodeClick(){
        CountDown.countDown(btn: codeBtn, phone: UserDefaults.getInfo()["phone"] as! String,
                            verify: imgCodeInput.text!, verifySign: imgSign!, type: 1,
        success: { (data) in
            if(data != "warning"){
                self.codeSign = data
            }
        })
    }
    
    //新绑定图片验证码
    @objc func imgCodeClick1(){
        AlamofireUtil.get(url: "/public/verifyCode",
        success: {(res,data) in
            self.codeImg1.image = UIImage(data: data)
            self.imgSign1 = res.allHeaderFields[AnyHashable("verifysign")] as? String
        },
        failure: {
        })
    }
    
    //新手机获取验证码
    @objc func phoneCodeClick1(){
        CountDown.countDown(btn: codeBtn1, phone: phoneInput.text!,
                            verify: imgCodeInput.text!, verifySign: imgSign!, type: 1,
        success: { (data) in
            if(data != "warning"){
                self.codeSign1 = data
            }
        })
    }
    
    //验证旧手机
    func checkPhone(){
        AlamofireUtil.post(url: "/user/info/public/phoneVerify",
        param: [
            "phone": UserDefaults.getInfo()["phone"] as! String,
            "phoneCode": codeInput.text!,
            "phoneSign": codeSign!
        ],
        success: { (res, data) in
            self.step = 2
            self.submitBtn.setTitle("确认修改", for: .normal)
            self.formList.isHidden = true
            self.formList1.isHidden = false
            //手动清除倒计时
            UserDefaults.standard.removeObject(forKey: "countDown")
        },
        error: {},
        failure: {})
    }
    
    @objc func submit (btn: UIButton) {
        if(step == 1){
            checkPhone()
        }else if(step == 2){
            if(phoneInput.text! == "" || codeInput.text! == "" || imgCodeInput.text! == ""){
                return
            }
            //待修改
            AlamofireUtil.post(url: "/user/info/public/phoneVerify",
            param: [
                "phone": UserDefaults.getInfo()["phone"] as! String,
                "phoneCode": codeInput.text!,
                "phoneSign": codeSign!
            ],
            success: { (res, data) in
                var info : [String : Any] = UserDefaults.getInfo()
                info["phone"] = self.phoneInput.text!
                UserDefaults.setInfo(value: info as! [String : String])
                IDToast.id_show(msg: "修改成功", success:.fail)
                self.navigationController?.popViewController(animated: true)
            },
            error: {},
            failure: {})
        }
    }
}
