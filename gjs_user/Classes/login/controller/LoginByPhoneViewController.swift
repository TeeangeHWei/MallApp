//
//  LoginByPhoneViewController.swift
//  gjs_user
//
//  Created by xiaofeixia on 2019/9/5.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class LoginByPhoneViewController: UIViewController {
    
    private var loginByPhone = LoginByPhoneView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH))
    private var step = 1
    private var verifySign:String! = ""
    private var phoneSign:String! = ""
    
    //自定义头部
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        setNav(titleStr: "手机号登录", titleColor: kMainTextColor, navItem: navigationItem, navController: navigationController)
        
        let leftBtn = UIBarButtonItem(title: "上一步", style: .plain, target: self, action: #selector(backBefore))
        leftBtn.tintColor = kHighOrangeColor
        leftBtn.setTitleTextAttributes([NSAttributedString.Key.font: FontSize(14)], for: .normal)
        self.navigationItem.leftBarButtonItem = leftBtn;
    }
    
    @objc func backBefore(){
        if(step == 1){
            navigationController?.popViewController(animated: true)
        }else{
            step -= 1
            nextStep()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        loginByPhone.nextBtn.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
        self.nextStep()
        self.view.addSubview(loginByPhone)

    }
    
    //下一步按钮
    @objc func nextStep() {
        self.loginByPhone.activeBtn(flag: false)
        if step == 1{
            loginByPhone.firstStep()
            loginByPhone.phone.addTarget(self, action: #selector(checkPhone), for: .editingChanged)
        }else if step == 2{
            loginByPhone.secondStep()
            self.verifyClick()
            loginByPhone.verifyImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(verifyClick)))
            loginByPhone.verify.addTarget(self, action: #selector(inputVerify), for: .editingChanged)
            loginByPhone.phoneCodeBtn.addTarget(self, action: #selector(phoneCodeClick), for: .touchUpInside)
        }else if step == 3{
            login()
        }
    }
    
    //验证手机号码（合法性，是否存在）限制11位，超出隐藏
    @objc func checkPhone(){
        if(loginByPhone.phone.text?.count == 11){
            self.loginByPhone.activeBtn(flag: false)
            if(Commons.isPhone(phone: loginByPhone.phone.text ?? "")){
                AlamofireUtil.post(url: "/user/autho/public/validatedPhone",
                param: [
                    "phone":loginByPhone.phone.text!
                ],
                success: {(res, data) in
                    if(data.description == "true"){
                        self.step = 2
                        self.loginByPhone.activeBtn(flag: true)
                    }else{
                        IDToast.id_show(msg: "手机号码不存在", success:.fail)
                    }
                },
                error: {
                },
                failure: {
                })
            }else{
                IDToast.id_show(msg: "手机格式错误", success:.fail)
            }
        }else if((loginByPhone.phone.text ?? "").count > 11){
            loginByPhone.phone.text = loginByPhone.phone.text?.id_subString(from: 0, offSet: 11)
        }else{
            self.loginByPhone.activeBtn(flag: false)
        }
    }
    
    //获取图片验证码
    @objc func verifyClick(){
        AlamofireUtil.get(url: "/public/verifyCode",
        success: {(res,data) in
            self.loginByPhone.verifyImg.image = UIImage(data: data)
            self.verifySign = res.allHeaderFields[AnyHashable("verifysign")] as? String
        },
        failure: {
        })
    }
    
    //校验图片验证码4位，获取短信验证码
    @objc func inputVerify(){
        if((loginByPhone.verify.text ?? "").count==4){
            self.phoneCodeClick()
        }else if((loginByPhone.verify.text ?? "").count > 4){ //超出部分截取
            loginByPhone.verify.text = loginByPhone.verify.text?.id_subString(from: 0, offSet: 4)
        }
    }
    
    //获取短信验证码
    @objc func phoneCodeClick(){
        CountDown.countDown(btn: loginByPhone.phoneCodeBtn, phone: loginByPhone.phone.text!,
                            verify: loginByPhone.verify.text!, verifySign: self.verifySign!, type: 1,
        success: { (data) in
            if(data != "warning"){
                self.phoneSign = data
            }
            self.loginByPhone.phoneCodeShow()
            //验证码输入结束（下一步）
            self.loginByPhone.phoneCode.inputFinish = { data in
                self.step = 3
                self.loginByPhone.activeBtn(flag: true)
            }
        })
    }
    
    func login(){
        IDLoading.id_showWithWait()
        AlamofireUtil.post(url: "/user/autho/public/loginByPhoneCode",
        param: [
            "phone":loginByPhone.phone.text!,
            "phoneCode":loginByPhone.phoneCode.text!,
            "phoneSign":self.phoneSign!
        ],
        success: {(res, data) in
            UserDefaults.setAuthoToken(value: data["token"].description)
            self.getInfo()
            IDLoading.id_dismissWait()
            IDToast.id_show(msg: "登录成功", success: .success)
            let vcCount = self.navigationController?.viewControllers.count
            self.navigationController?.popToViewController((self.navigationController?.viewControllers[vcCount! - 3])!, animated: true)
        },
        error: {
        },
        failure: {
        })
    }
    
    // 获取用户信息
    func getInfo(){
        AlamofireUtil.post(url:"/user/info/getUserInfo", param: [:],
        success:{(res, data) in
            // 获取并将用户信息保存到缓存中
            UserDefaults.setInfo(value: data.dictionary!.compactMapValues({ (data) -> String? in
                data.description
            }))
        },
        error:{},
        failure:{})
    }
}
