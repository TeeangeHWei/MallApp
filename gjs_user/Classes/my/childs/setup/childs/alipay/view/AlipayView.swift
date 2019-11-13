//
//  Alipay  alipayView.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/19.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class AlipayView: ViewController {
    
    private var allHeight = 0
    let nameCenter = IDTextField()
    let alipayCenter = IDTextField()
    let imgcodeCenter = IDTextField()
    let codeCenter = IDTextField()
    let codeImg = UIImageView()
    let codeBtn = UIButton()
    private var imgCodeSign:String!
    private var codeSign:String!
    
    override func viewDidLoad() {
        let navView = customNav(titleStr: "绑定支付宝", titleColor: kMainTextColor)
        self.view.addSubview(navView)
        let body = UIScrollView(frame: CGRect(x: 0, y: headerHeight, width: kScreenW, height: kScreenH - headerHeight))
        body.backgroundColor = kBGGrayColor
        body.addBorder(side: .top, thickness: 1, color: klineColor)
        body.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.height = YGValue(kScreenH - headerHeight)
            layout.paddingTop = 1
        }
        self.view.addSubview(body)
        
        // 表单列表
        let formList = UIView()
        formList.backgroundColor = .white
        formList.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(kScreenW)
            layout.marginTop = 10
        }
        body.addSubview(formList)
        // 真实姓名
        let realName = formItem(leftS: "真实姓名")
        formList.addSubview(realName)
        nameCenter.clearButtonMode = .whileEditing
        nameCenter.font = FontSize(14)
        nameCenter.placeholder = "请输入真实姓名"
        nameCenter.text = UserDefaults.getInfo()["alipayRealname"] as! String
        nameCenter.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue((kScreenW - 30) * 0.7)
        }
        realName.addSubview(nameCenter)
        // 支付宝账号
        let alipay = formItem(leftS: "支付宝账号")
        formList.addSubview(alipay)
        alipayCenter.clearButtonMode = .whileEditing
        alipayCenter.font = FontSize(14)
        alipayCenter.placeholder = "请输入支付宝账号"
        alipayCenter.text = UserDefaults.getInfo()["alipayAccount"] as! String
        alipayCenter.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue((kScreenW - 30) * 0.7)
        }
        alipay.addSubview(alipayCenter)
        // 手机号码
        let phone = formItem(leftS: "手机号码")
        formList.addSubview(phone)
        let phoneCenter = UILabel()
        phoneCenter.text = UserDefaults.getInfo()["phone"] as! String
        phoneCenter.font = FontSize(14)
        phoneCenter.textColor = kLowGrayColor
        phoneCenter.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue((kScreenW - 30) * 0.5)
        }
        phone.addSubview(phoneCenter)
        // 图片验证码
        let imgCode = formItem(leftS: "图片验证码")
        formList.addSubview(imgCode)
        imgcodeCenter.clearButtonMode = .whileEditing
        imgcodeCenter.font = FontSize(14)
        imgcodeCenter.placeholder = "请输入图片验证码"
        imgcodeCenter.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue((kScreenW - 30) * 0.5)
        }
        imgCode.addSubview(imgcodeCenter)
        imgCodeClick()
        codeImg.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue(69)
            layout.height = YGValue(30)
        }
        codeImg.isUserInteractionEnabled = true
        codeImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imgCodeClick)))
        imgCode.addSubview(codeImg)
        // 验证码
        let code = formItem(leftS: "验证码")
        formList.addSubview(code)
        codeCenter.clearButtonMode = .whileEditing
        codeCenter.font = FontSize(14)
        codeCenter.placeholder = "请输入验证码"
        codeCenter.configureLayout { (layout) in
            layout.isEnabled = true
            layout.width = YGValue((kScreenW - 30) * 0.5)
        }
        code.addSubview(codeCenter)

        CountDown.countDownSchedule(btn: codeBtn)
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
        codeBtn.addTarget(self, action: #selector(phoneCodeClick), for: .touchUpInside)
        code.addSubview(codeBtn)
        
        // -------- 提交按钮 --------
        let submitBtn = UIButton(frame: CGRect(x: 0, y: 0, width: kScreenW * 0.8, height: 40))
        submitBtn.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), kCGGradientColors)
        submitBtn.setTitle("立即绑定", for: .normal)
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
            layout.marginTop = 20
            layout.marginLeft = YGValue(kScreenW * 0.1)
        }
        submitBtn.addTarget(self, action: #selector(submint), for: .touchUpInside)
        body.addSubview(submitBtn)
        
        body.yoga.applyLayout(preservingOrigin: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // 表单单项
    func formItem (leftS: String) -> UIView {
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
        return formItem
    }
    
    //获取图片验证码
    @objc func imgCodeClick(){
        AlamofireUtil.get(url: "/public/verifyCode",
        success: {(res,data) in
            self.codeImg.image = UIImage(data: data)
            self.imgCodeSign = res.allHeaderFields[AnyHashable("verifysign")] as? String
        },
        failure: {
        })
    }
    
    //获取验证码
    @objc func phoneCodeClick(){
        CountDown.countDown(btn: codeBtn, phone: UserDefaults.getInfo()["phone"] as! String,
                            verify: imgcodeCenter.text!, verifySign: imgCodeSign, type: 1,
        success: { (data) in
            if(data != "warning"){
                self.codeSign = data
            }
        })
    }
    
    @objc func submint(){
        if(nameCenter.text! == "" || alipayCenter.text! == "" || imgcodeCenter.text! == "" || codeCenter.text! == ""){
            IDToast.id_show(msg: "请填写完整信息", success: .fail)
            return
        }
        //待修改
        AlamofireUtil.post(url: "/user/info/bindAlipay",
        param: [
            "alipayRealname":nameCenter.text!,
            "alipayAccount":alipayCenter.text!,
            "phoneCode":codeCenter.text!,
            "phoneSign":codeSign,
        ],
        success: { (res,data) in
            var info : [String : Any] = UserDefaults.getInfo()
            info["alipayRealname"] = self.nameCenter.text!
            info["alipayAccount"] = self.alipayCenter.text!
            UserDefaults.setInfo(value: info as! [String : String])
            IDToast.id_show(msg: "绑定成功", success: .success)
            self.navigationController?.pushViewController(SetupView(), animated: true)
        },
        error: {},
        failure: {})
    }
}
